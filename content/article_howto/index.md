---
title: How to read my articles
---

# How to read my articles

## Target audience

I'm not targeting the complete beginner.  I expect you know your system well enough to navigate around, edit files, read manpages and install software.

I will describe on which System / OS a post is based on. If you apply this knowledge to a different Environment, I expect you know how to adapt the article accordingly (use different paths, devices names etc..).

# Syntax I use

I use prefixes to indicate that a command should be run on the command line. Depending on the prefix, the command should be run as user, or superuser (root).
```
$ command       : execute command as user
# command       : execute command as root
```

I refer to manual pages in the format [printf(3)](https://man.openbsd.org/printf.3), which can be read using the command `$ man 3 printf`. The sections and their meaning are described in [man(1)](https://man.openbsd.org/man.1). I'm linking to manpages on [man.openbsd.org](https://man.openbsd.org), which is the system I am using. Commands and options may be different to other operating systems. Compare man pages in order to figure out what will work for you.

I use three types of placeholders:
```
$username       : This placeholder contains the same content across the article
<filename>      : This placeholder can be different on every use
[something]     : This placeholder shows something optional
[...]           : Something irrelevant to the post is here, so I'm not showing it.
```

