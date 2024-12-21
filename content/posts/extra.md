+++
date = '2024-12-21T08:26:27+01:00'
draft = true
title = 'Serve files as text in OpenHTTPd'
tags = ['OpenBSD', 'OpenHTTPd']
+++

## Extra: Adding more file extensions

```
$ curl -I https://ptrace.org/logtest.log
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 12546607
Content-Type: application/octet-stream
Date: Sat, 21 Dec 2024 08:52:16 GMT
Last-Modified: Sat, 14 Dec 2024 15:41:19 GMT
Server: OpenBSD httpd
```

{{< callout >}}
The "utf-8" charset is an extension to the default "us-ascii" charset and therefore compatible.
{{< /callout >}}


Without "log" being added to the list of text/plain files, it would not be known to httpd. And unknown files, are being sent with Content-Type "application/octet-stream", which browsers cannot display and therefore download.

This is a text file, but the browser would instantly download it, instead if displaying it:

```
$ curl -I https://ptrace.org/unknown.foo
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 30
Content-Type: application/octet-stream
Date: Sat, 21 Dec 2024 08:54:35 GMT
Last-Modified: Sat, 21 Dec 2024 08:54:27 GMT
Server: OpenBSD httpd
```

