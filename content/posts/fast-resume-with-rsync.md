+++
date = '2024-12-23T08:54:59+01:00'
draft = true
title = 'Fast Resume With Rsync'
+++

I'm using `rsync` a lot, to transfer files form A &rarr; B with the option to interrupt and resume the transfer later. 

```
$ rsync -rP A/ remote:B/
```

This translates to:

```
-r, --recursive     recurse into directories
-P                  same as --partial --progress
    --partial       keep partially transferred files
    --progress      show progress during transfer
```

This leads to rsync leaving behind partial files, which it will "resume" when the command is run again. These are "safe" commands, and even if the file content on sender side changes completely before the transfer is continued, rsync will detect it and retransfer the file.

This works, because before continuing a file, rsync checks the existing file content using checksums an both, sender and receiver side. This means on both sides, the rsync process checksums the existing content completely, and then only the checksum is compared over the network. That's very easy on the network, but very heavy on the CPU.

However, if the CPU on one side of the transfer is weak, it can happen that checksumming a big file can take longer than re-transferring it. That's annoying.

## There is a faster way...

...if files are not modified during the interruption.

Let's say I transfer `bigfileA` to `remote:`, and press `ctrl+c` half way through because I need to reboot my laptop. After the reboot I want to continue.

The content of `bigfileA` didn't change. The partial file `remote:bigfileA` also hasn't been altered. I simply want the transfer to continue where it left of.

In this case it is unnecessary to let rsync checksum the full, already transferred content. We know nothing changed there.

Let's use some other options:

```
$ rsync -rP A/ remote:B/
```

This translates to:

```
-r, --recursive     recurse into directories
-P                  same as --partial --progress
    --partial       keep partially transferred files
    --progress      show progress during transfer
```


