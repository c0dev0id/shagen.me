+++
date = '2024-12-21T08:26:27+01:00'
draft = true
title = 'Fixing OpenHTTPd text encoding'
tags = ['OpenBSD', 'OpenHTTPd']
+++

I'm serving a lot of text files with my web server and I want them to be displayed correctly.

## The Problem: Garbled Unicode Text

The default encoding for the `text/plain` Content-Type is `us-ascii` as specified in [RFC1341](https://www.w3.org/Protocols/rfc1341/7_1_Text.html).
This default is wrong when a text file contains characters that are not part of the default charset, like umlauts, emojis.
The result is garbled text:

![Image of garbled unicode characteres](/images/utf8text-bad.png)

## Understanding the Content-Type Header

Header fields can be explored with [curl](https://curl.se).

```
$ curl -I https://ptrace.org/plaintext.txt
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 2941
Content-Type: text/plain
Date: Sat, 21 Dec 2024 07:48:13 GMT
Last-Modified: Tue, 15 Oct 2024 05:30:40 GMT
Server: OpenBSD httpd
```

The Content-Type can be seen as the web-version of the file extension.
Header fields are delivered before the actual file, and contain various instructions for the browser that are useful to know before starting to load the data.

The browser knows which content types it can handle.
If an unknown content type is encountered, the data is offered for download.

Some examples:

- text/html &rarr; needs to be processed (rendered) and the result is displayed
- text/plain &rarr; can be displayed without processing
- text/xml &rarr; can be reformatted nicely and then displayed
- application/pdf &rarr; can be displayed using the pdf viewer plugin
- video/mp4 &rarr; can be displayed using the video player plugin
- image/jpeg &rarr; can be displayed using the jpeg library

For binary content types like video and images, this is sufficient, because there's no encoding in place.

## Why a text-type is not sufficient

For text based content types, like text, xml, html and so on, this is *not* sufficient.
Technically, text is binary data as well, but there are different ways of make readable text out of this data.

In the early computer days, when memory was sparse, only the most necessary characters were supported.
Those were the 127 characters defined in [us-ascii](https://man.openbsd.org/ascii.7).
As mentioned in the beginning, this is the default character set for content type `text/plain`.

There's no "ö", no "ä", no "ü", no "ß" in us-ascii, and therefore these character cannot be displayed.

However, one ascii character is stored in one byte.
And one byte has 8 bits, which can store 256 values (2^8).

That means us-ascii only occupies half of the space.
When computers got more popular, users demanded their local characters to be displayed on the screen.

The half byte that could be used in addition is not enough for all of the worlds characters and symbols.

The solution was to make the second half of the byte switchable.
And this switch is called [Code Page](https://en.wikipedia.org/wiki/Code_page).
The code page idea was not new. It was taken from another encoding, which happened to exist in parallel to ascii.
It was called EBCDIC, and was developed and used by IBM. EBCDIC had code pages already.

The code page concept was then adapted in ASCII (or 8 Bit ASCII).

Here is the byte value of character "ö" in different encodings:

- Extended ASCII ([Code Page 819](https://www.ascii-code.com/ISO-8859-1)) &rarr; `0xf6`
- Extended ASCII ([Code Page 1252](https://www.ascii-code.com/CP1252)) &rarr; `0xfc`
- Extended ASCII ([Code Page 437](https://www.ascii-code.com/CP437)) &rarr; `0x94`
- EBCDIC ([CCSID 7](https://en.wikibooks.org/wiki/Character_Encodings/Code_Tables/EBCDIC/EBCDIC_007)) &rarr; `0xd0`

Now it's clear that the information "this data is of type text" is not sufficient to read it:

If we see a byte with value `0x94`, we don't know what character it is without additional information.
In ASCII with Code Page 437, it is "ö".
In ASCII with Code Page 819, this code point is unused.
In EBCDIC Code Page 7, it would be the character "m".

These combinations adds up to hundreds of ways how data can be interpreted as text.
And it explains why selecting the wrong encoding often only leads to half of the characters being garbled.

Luckily, most of this mess is [history](https://en.wikipedia.org/wiki/Character_encoding#History) now, thanks to the development of unicode, which defines an encoding that can take up to 4 bytes and is big enough for all the language characters in existence... and emojis.

Unicode itself is is a concept of how code points are organized. The technical encoding exists in more than one flavor, however, the [most common character encoding](https://en.wikipedia.org/wiki/Popularity_of_text_encodings) is [UTF-8](https://en.wikipedia.org/wiki/UTF-8).

UTF-8 is a variable width encoding, which means it can store common characters in one byte, but can use up to 4 bytes per character to address rarely used characters. In addition to that, it's compatible with us-ascii, which means the first 127 characters are byte compatible between ascii and utf-8.

This means utf-8 can be use instead of ascii without breaking compatibility. A valid 7-bit ascii file, it also a valid utf-8 file.

## The solution: Content-Type charset subtype

In the previous chapter, I described that knowing that some data is text, is not sufficient to interpret the data.

For this reason, the Content-Type header supports an additional subtype. This subtype can contain charset information, which can give more details about the encoding of the text. Like `Content-Type: text/html charset=latin1` would announce a [ISO-8859-1](https://www.charset.org/charsets/iso-8859-1) document by it's nickname "latin1".

In practical terms, it's rare nowadays to encounter text that's not utf-8 compatible, and therefore the solution is to add the utf-8 charset information to the text/plain type of the Content-Type header.

## Fixing the OpenHTTPd configuration

Let's start by making OpenHTTPd aware of more mime types.

The [documentation](https://man.openbsd.org/httpd.conf.5#TYPES) shows how to add a list of mime types to `/etc/httpd.conf`:

```
types {
    include "/usr/share/misc/mime.types"
}
```

This makes OpenHTTPd aware of all the default content types described in this file.
The file `/usr/share/misc/mime.types` contains the following line, which creates a link between the file extension `.txt` and the type, that is delivered using the Content-Type Header.

```
text/plain                     txt
```

This line needs to change.
Instead of including the file, the content can also be added to `/etc/httpd.conf` directly.

{{< callout >}}
**Do not change /usr/share/misc/mime.types directly, it will be overwritten with the next OpenBSD Upgrade.**
You can create a modified copy and include the copy instead.
{{< /callout >}}

The charset can be added to the `text/plain` entry by changing it to `text/"plain; charset=utf-8"`.
The quotes are needed, otherwise charset=utf-8 would be interpreted as file extension, which would be invalid and httpd wouldn't start.

```
types {
    application/atom+xml         atom
    application/font-woff        woff
    application/java-archive     jar war ear
    ...
    text/"plain; charset=utf-8"  txt
    ...
    video/x-ms-asf               asx asf
    video/x-ms-wmv               wmv
    video/x-msvideo              avi
}
```

*It's not necessary to add all the mime-types, but it's a good idea to do so.*

With this configuration, the the proper Content-Type header with charset subtype will be delivered and textfiles containing unicode characters will be displayed correctly.

```
$ curl -I https://ptrace.org/utf8text.txt
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 98
Content-Type: text/plain; charset=utf-8
Date: Sat, 21 Dec 2024 08:15:02 GMT
Last-Modified: Sat, 21 Dec 2024 07:53:26 GMT
Server: OpenBSD httpd
```

![Image of properly displayed unicode characteres](/images/utf8text-good.png)

[^1]: I know there's also the file MAGIC. But here's no such concept in the web-world.
