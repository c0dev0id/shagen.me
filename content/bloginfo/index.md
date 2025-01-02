---
layout: standalone
title: Blog Information
---

# Target Audience

I'm not targeting the complete beginner.

I expect you know your system well enough to navigate around, edit files, read manpages and install software.

I will describe on which System / OS a post is based on. If you apply this knowledge to a different Environment, I expect you know how to adapt the article accordingly (use different paths, devices names etc..).

# Syntax I use

## "$": Execute as user

Commands that should be executed as user, are prepended with `$`:

```
$ scrot -s 
```

## "#": Execute as root

Commands that should be executed as root, are prepended with `#`.

```
# fdisk /dev/sda
```

## "man(1)": Manpages

You will see text or links like this: [video(1)](https://man.openbsd.org/video.1). This carries the following information:
- I want you to read the manpage
- The manpage is in section 1 (see [man(1)](https://man.openbsd.org/man.1) `-s` switch) and can be read with `man 1 video`
- Based on the section, it show that it's a command, which differentiates it from the [video(4)](https://man.openbsd.org/video.4) device driver.

## "$var": Placeholder

I use three types of placeholders:
- `$something`: Shell style placeholders should contain the same content whenever it is used.
- `<something>`: This placeholder can contains something different whenever it is used.
- `[something]`: This placeholder shows something that's optional
- `[...]`: This placeholder shows that something has been skipped


## Codeblock comments

I use the environment specific comment syntax:
- `#` in shell, perl, yaml, ...
- `//` or `/* */` in C, C++, ...
- `<!-- -->` in HTML
- `-- ` in Lua
- ...

Additionally, I may point at something with arrows `<--- like here`.

Or I use poor mans callouts by placing `[1]` on lines and describe these lines below the code block.

```
$ usbdevs
Controller /dev/usb0:
addr 01: 1022:0000 AMD, xHCI root hub
addr 02: 05e3:0610 Genesys Logic, USB2.0 Hub
# this is a shell style comment and not part of the output
Controller /dev/usb1:
addr 01: 1022:0000 AMD, xHCI root hub    <--- this comment tell you to check xhci(4)
addr 02: 30c9:00cd 8SSC21K64624V1SR47D21S9, Integrated Camera    [1]
Controller /dev/usb2:
addr 01: 1022:0000 AMD, xHCI root hub
Controller /dev/usb3:
addr 01: 1022:0000 AMD, xHCI root hub
```

- [1]: If there's a lot to describe or many different parts to describe,
I use this style of callout to reference parts in the output.
