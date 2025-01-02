---
layout: standalone
title: Blog Information
---

# Blog Information

Here's some information you should know when you read my blog articles.

- I'm not targeting the complete beginner.
- I expect you know your system well enough to navigate around, edit files, read manpages and install software.
- I will describe on which System / OS the blog post is based on. If you apply this knowledge to a different System / OS, I expect you know how to adapt the article accordingly (use different paths, devices names etc..).

The first three are most imporant. The ones below shall be common sense.

## Syntax I use

I use a certain syntax in my code examples.

## "$" Execute as user

Commands that should be executed as user, are prepended with `$`:

```
$ scrot -s 
```

## "#" Execute as root

Commands that should be executed as root, are prepended with `#`.
It doesn't matter if they are executed using `sudo` or `doas` or by switching to root with `su` first.
It just means this command needs root permissions. It's up to you how you achieve that.

```
# fdisk /dev/sda
```

## Manpages

You will see text or links like this: [video(1)](https://man.openbsd.org/video.1). This carries the following information:
- I want you to read the manpage
- The manpage is in section 1 (see [man(1)](https://man.openbsd.org/man.1) `-s` switch) and can be read with `$ man 1 video`
- Based on the section, it show that it's a command, which differentiates it from the [video(4)](https://man.openbsd.org/video.4) device driver.

## Placeholder

I use three types of placeholders:
- `$something`: Shell style placeholders should contain the same content whenever it is used.
- `<something>`: This placeholder can contains something different whenever it is used.
- `[something]`: This placeholder shows something that's optional
- `[...]`: This placeholder shows that something should be there, but has been skipped to shorten the command

Examples:
```
$ chmod $user:$group <file>
$ $editor /etc/httpd.conf
$ ffmpeg [...] -o <file>.mp4
$ curl -H "Content-Type: application/json" [moreheaders] --data "$data"
```

And this is the same user + group as above, but can be a different file.
```
# chmod $user:$group <file>
```

## Command output

Here you see the `df -h .` command, which should be run as user.
The next two lines are the output of this command, and don't have a prefix.

```
$ df -h .
Filesystem     Size    Used   Avail Capacity  Mounted on
/dev/sd1p      1.4T    1.3T    6.8G   100%    /home
```

## Codeblock comments

Sometimes, I add a comment to a command. I do this by adding either a `# comment` inline or `# (<nr>)` to described something below.

```
$ usbdevs
Controller /dev/usb0:
addr 01: 1022:0000 AMD, xHCI root hub
addr 02: 05e3:0610 Genesys Logic, USB2.0 Hub    # this is a comment
Controller /dev/usb1:
addr 01: 1022:0000 AMD, xHCI root hub
addr 02: 30c9:00cd 8SSC21K64624V1SR47D21S9, Integrated Camera    # (1)
Controller /dev/usb2:
addr 01: 1022:0000 AMD, xHCI root hub
Controller /dev/usb3:
addr 01: 1022:0000 AMD, xHCI root hub
```

- (1): if comments are getting longer, I use this format.

## File output

I use `[...]` to indicate that I'm not showing the complete file.
The hidden parts are not important in the context of the post.

This example shows only the first line of `/etc/resolv.conf`:
```
nameserver 127.0.0.1 # resolvd: unwind
[...]
```

Another way to show relevant lines of a file is by using a command:
```
$ cat /etc/resolv.conf | grep resolv
nameserver 127.0.0.1 # resolvd: unwind
#nameserver 10.20.30.1 # resolvd: trunk0
```

## Use of regular expressions

Sometimes it's just easier, and even clearer to write to `s/my.domain/$domain/g` in `/etc/hostname.*` than the textual explanation, that would be: "Replace all occurances of "my.domain" in all files in /etc that start with "hostname.", with your domain.".

If written that way, I want you to do it in an editor. Mostly because I haven't tried running `$ sed -i "s/my.domain/$domain/g" /etc/hostname.*`.

In case I used `sed`, I'll write it as a command:

```
# sed -i "/$(hostname -s)/$newhostname/" /etc/myname
```

