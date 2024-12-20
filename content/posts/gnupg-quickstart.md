+++
date = '2019-05-21T22:10:01+01:00'
draft = true
title = 'Gnupg Quickstart'
+++

I love GPG and the way it works. I know there are many that complain
about it because it has flaws. My stance on this is that I prefer
battle-tested software with known flaws to something with unknown flaws.

This post should get you started with GnuPG.

## Installation

Install gpg and pinentry.

```
$ pkg_add gnupg pinentry
```

## Generating keys

If you want to lock and unlock stuff, you need a key. This is how you 
get to one:

```
$ gpg --generate-key
```

Hop through the wizard until you see these lines:

```
pub   rsa3072 2021-05-19 [SC] [expires: 2023-05-19]
      BA696588D9A04AD9F70DA33EC54733F6DBECC2C1
uid                      John Doe <j.doe@example.com>
sub   rsa3072 2021-05-19 [E] [expires: 2023-05-19]
```

If you see an error like:

```
gpg: agent_genkey failed: Permission denied
```

Add the following entry and try again.

```
$ cat ~/.gnupg/gpg-agent.conf
allow-loopback-pinentry
```

Congratulations, you got yourself a GPG Key. This long gibberish is
your full GPG Key ID. Most of the time, you can simply use the last 8
characters. So the short version of this GPG Key is DBECC2C1.

You can set it as default key, so it's used to encrypt stuff when no
explicit key is given.

```
$ cat ~/.gnupg/gpg.conf
default-key DBECC2C1
```

## Share the public key with people

If you want someone to be able to encrypt something for you, send him or 
her the output of:

```
$ gpg --export -a DBECC2C1
```

You can also use your email address instead of the Key ID, if you have
only one key with it. This key is public. So put it on some webspace and
add a link to your email header or signature.

## Upload the key so people can search for it

{{< callout >}}
Uploading your key will expose your public key and all associated email adresses to the public.
{{< /callout >}}

You can upload your key to [key.opengpg.org](https://keys.openpgp.org).
Do not use other keyservers like the sks-keyservers. They're broken.

You also configure the keyserver in GnuPG:

```
$ cat ~/.gnupg/gpg.conf
keyserver hkps://keys.openpgp.org

```

Then upload your key using gpg:

```
$ gpg --send-keys DBECC2C1
```

## Import public keys from others

Add a key from someone else to gnupg, so you can use it to encrypt data 
for this person. If the key is on your harddrive, use:

```
$ gpg --import <pubkeyfile.asc>
```

The file ending here is kind of undefined. Some call it .asc, .gpg, .pub
or .key. If the key is on a key server, you can import it like so:

```
$ gpg --recv-key 52BE43BA
```

This would import my key. You can look at it now with:

```
$ gpg --list-keys 52BE43BA
```

You can update all keys with new versions from the key server with:

```
$ gpg --refresh-keys
```

## Encrypt a file

This encrypts the file plain.txt with the public key DBECC2C1.

```
$ gpg -e -r DBECC2C1 file.txt
```

Now you have file.txt.gpg, which is the encrypted version


## Decrypt a file

GnuPG automaticall figures out what key it can use to decrypt a file. So 
tthis will output the content of file.txt on the terminal. If you want 
tto save the output in a file, add -o file.txt.

```
$ gpg -d file.txt.gpg 
$ gpg -o file.txt -d file.txt.gpg
```

## Other password prompts (pinentry)

You can change the way gpg asks for the password:

```
$ cat ~/.gnupg/gpg-agent.conf
pinentry-program /usr/local/bin/pinentry-curses
```

Options are:
  - pinentry (sometimes also called pinentry-tty)
  - pinentry-curses
  - pinentry-gtk2: pkg_add pinentry-gtk2
  - pinentry-gnome3: pkg_add pinentry-gnome3
  - pinentry-dmenu: https://github.com/ritze/pinentry-dmenu

{{< callout >}}
Note: If you use a console pinentry program and want to use gpg with a
GUI tool (like thunderbird), the password prompt will be invisible and
gpg/thunderbird will freeze.
{{< /callout >}}

Makes sense, doesn't it?

## Password Caching with gpg-agent

Put this in your `.kshrc` or `.bashrc`:

```
$ cat ~/.kshrc
export GPG_TTY=$(tty)
gpg-connect-agent /bye
```

## Backup your keys!

There is no handholding cloud or support team you can call when you 
messed up or deleted your key. So back it up safely.

Either you backup your ~/.gnugp directory, or you export the secret 
keys and backup them safely.

```
$ gpg --export-secret-keys -a DBECC2C1 > gpg_key_backup.sec
```

Seriously, don't skip this step.

## Configure Mutt

Install mutt with the gpgme flavor. Gpgme is the "new way" of handling 
gpg in mutt.

```
$ pkg_add mutt--gpgme
```

If you're not on OpenBSD, check with `mutt -v` if it was compiled with
tthe --enable-gpgme option. Then enable it in mutt.

```
$ cat ~/.muttrc
crypt_use_gpgme = yes
```

In the mutt compose view, you can now select Security Options.

```
        From: C0dev0id <c0@example.com>
          To: j.doe@example.com
          Cc:
         Bcc:
     Subject: Hello my friend
    Reply-To:
         Fcc: =Sent
    Security: Sign, Encrypt (PGP/MIME)
     Sign as: <default>
```

You can change the setting with the key "p", which should bring up a
selection menu.

```
PGP (e)ncrypt, (s)ign, sign (a)s, (b)oth, s/(m)ime or (c)lear?
```

