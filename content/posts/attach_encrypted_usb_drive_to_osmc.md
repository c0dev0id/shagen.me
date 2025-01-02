+++
date = '2025-01-01T20:05:13+01:00'
draft = true
title = 'Attach encrypted USB disk to OSMC'
+++

{{< blogintro >}}

## Preparation

Attach the USB disk to the OSMC device.
Know which device it is (`dmesg` or `fsblk`) and make sure it's not mounted (OSMC automatically mounts devices with a known file system).
Have the required packages installed: `apt-get install cryptsetup`


## Create crypto device

The device `/dev/sdc` is my external USB drive.

```
# cryptsetup luksFormat --type=luks2 /dev/sdc

WARNING!
========
This will overwrite data on /dev/sdc irrevocably.

Are you sure? (Type 'yes' in capital letters): YES
Enter passphrase for /dev/sdc:
Verify passphrase:
```

## Register crypto device in crypttyp

Get the device UUID

```
#  lsblk /dev/sdc -o UUID
UUID
2bff48cb-9b74-4c61-8974-814314750f99
```

And create an entry in `/etc/crypttab`:

```
usbdisk UUID=2bff48cb-9b74-4c61-8974-814314750f99 none luks,discard,noauto
```

- usbdisk: this will be the name of the mapper device
- UUID=...: this is the UUID of the physical device 
- discard: enables trim support
- noauto: do not try to mount at boottime

Once this entry is present, the device can be started using `cryptdisks_start`

```
# cryptdisks_start usbdisk
```

## Add a file system

This is optional, but properly a good idea. Write random data over the whole crypto device. This makes the device look uniform and wipes out anything unencrypted, that may have been on it before.

```
# dd if=/dev/urandom of=/dev/mapper/usbdisk bs=4M status=progress
```

Create a file system. I choose ext4:

```
# mkfs.ext4 -m 0 -L 1TB /dev/mapper/usbdisk
```

- -m 0: reserve 0% of the space for root
- -L ...: sets the label of the device

## Add an fstab entry for easier mounting

Create an `/etc/fstab` entry like this:

```
/dev/mapper/usbdisk /mnt/1TB ext4 noauto,user 0 0
```

Now you should be able to mount the device as user:

```
$ mount /mnt/1TB
```

## Enable trim

The crypttab tries to set the discard flag already, but the device doesn't allow this feature yet. You can check the device flags with `cryptsetup luksDump`.

```
# cryptsetup luksDump /dev/sdc | grep Flags
Flags:          (no flags)
```

Enable trim and check again. You should see the `allow-discards` flag set afterwards.

```
# cryptsetup --allow-discards --persistent refresh /dev/mapper/usbdisk
```

If the physical device allows trim you can run:

```
# fstrim --fstab --verbose --dry-run
/: 0 B (0 bytes) trimmed on /dev/osmcroot
/mnt: 0 B (0 bytes) trimmed on /dev/mapper/usbdisk
```

On OSMC, the fstrim timer is active. Check with:

```
# systemctl status fstrim.timer
```

If not, you can enable it with:

```
# systemctl enable fstrim.timer
```
