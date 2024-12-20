+++
date = '2020-05-17T19:01:08+01:00'
draft = true
title = 'Browser Dark Mode Settings'
+++

## Chrome

Dark mode can be turned on using a command line switch:

```
$ chrome --enable-features=WebUIDarkMode --force-dark-mode
```

## Firefox

1. Go to "about:config"
2. Enter "ui.systemUsesDarkTheme" into the search bar
3. Click "Number" and then "+"
4. Enter "1" and click the check mark

Right click on a free spot in the icon bar and select "customize".
At the bottom left of the screen, you can switch to a dark theme.

Note: If you've set privacy.resistFingerprinting to "true" the CSS dark mode switching won't work.
Kudus to @andinus@tilde.zone for figuring this out.

## vim-browser (vimb)

Add the following line to `$HOME/.config/vimb/config`:

```
set dark-mode=true
```
