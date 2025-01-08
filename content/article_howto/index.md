---
layout: standalone
title: How to read my articles
---

# How to read my articles

## Target audience

I'm not targeting the complete beginner. I expect you know your system well enough to navigate around, edit files, read manpages and install software.

I will describe on which System / OS a post is based on. If you apply this knowledge to a different environment, I expect you know how to adapt the article accordingly (use different paths, devices names, command arguments etc..).

## Syntax I use

I'm using a consistent syntax in my articles:


For terminal commands:
```
$ command       : execute command as user
# command       : execute command as root
```


For manpages:
```
video(1)        : read manpage in section 1 for "video"
```

The sections and their meaning are described in [man(1)](https://man.openbsd.org/man.1). I'm linking to manpages on [man.openbsd.org](https://man.openbsd.org). Commands and options may be different to other operating systems. Compare man pages in order to figure out what will work for you.


For variable parts:
```
$username       : mandatory, same content across the article
<filename>      : mandatory, different content on each use
[something]     : optional, different content on each use
[...]           : Something irrelevant is skipped here
```

