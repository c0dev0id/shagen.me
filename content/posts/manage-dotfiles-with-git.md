+++
date = '2019-04-27T21:57:23+01:00'
title = 'Manage Dotfiles With Git'
+++

I'm managing my [dotfiles](https://git.uugrn.org/sdk/dotfiles) with git.
My method serves me very well for a many years already and so I think it's
time to write it down.

If you think git, you might think of a dotfile repository and dozens of
symlinks into the home directory. This is precisely what kept me from
using git until I discovered bare repositories.

Create your dotfile repository with the `--bare` parameter

```
$ git init --bare $HOME/.cfg
```

This creates only a folder for git control files, which normally resides
inside the `.git` folder within the repository.

You can now tell git to use `$HOME` as your work-tree directory. This
makes git handle your home directory like all the files would be within
the git repository. Now you can do:

```
$ git --git-dir=$HOME/.cfg/ --work-tree=$HOME add .vimrc
$ git --git-dir=$HOME/.cfg/ --work-tree=$HOME commit -m "my .vimrc"
```

If course it is silly to type out such a long command every time you
want to interract with your dotfiles. So we create an alias for it:

```
$ alias dotfiles='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

Put this in your `.bashrc` or `.kshrc` and you can now use the command
"dotfiles" in the same way you usually use the command `git`.

```
$ dotfiles add .vimrc
$ dotfiles commit -m "my vimrc"
```

Maybe you were brave and typed `dotfiles status` already. This will list
the content of your whole home directory as "untracked files". This is
not what we want. We can run `dotfiles config` and tell it to stop doing
this:

```
dotfiles config --local status.showUntrackedFiles no
```

Now `dotfiles status` will only check what's being tracked. If you add your
vimrc file and later change it, `dotfiles status` will show it, `dotfiles diff`
will diff it...

You can now use the power of git with your new "dotfiles" command.

If you're as lazy as I am, and don't care about carefully curated commit messages,
you can create an autoupdate function in your shellrc like this:

```
dotfiles-autoupdate() {
    MSG="Update $(date +"%Y-%m-%d %H:%M") $(uname -s)/$(uname -m)"
    config add -u && \
    config commit -m "$MSG" && \
    config push
}
```

This command takes all changed files and commits them with the date and
some machine information. Not creative, but I don't care. YMMV.

