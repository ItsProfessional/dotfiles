# My dotfiles

This repository contains dotfiles for my system.

## Installation

* Install `git` and `stow` on your system. For arch, use:
```sh
$ pacman -S git stow --needed
```

* Clone the repository.
```sh
$ cd $HOME
$ git clone git@github.com/ItsProfessional/dotfiles.git
$ cd dotfiles
```

* Create the symlinks
```sh
$ stow .
```

