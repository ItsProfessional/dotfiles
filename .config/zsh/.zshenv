## Environment
# XDG Base Directory
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_STATE_DIR=$HOME/.local/state
export XDG_DATA_DIRS=/usr/local/share:/usr/share
export XDG_CONFIG_DIRS=/etc/xdg

# Path
  # Add scripts directories to path
  path=("$HOME/scripts" "$HOME/.local/bin" "$XDG_DATA_HOME/cargo/bin" $path)
  for _dir in `find $HOME/scripts/ -type d`; do
    path=("$_dir" $path)
  done

  typeset -U path

  export PATH

# Editors, terminal, etc.
    export VISUAL=nvim
    export EDITOR=nvim
    export DIFFPROG="nvim -d"
    export TERMINAL=wezterm

# Change dotfile locations
    # History files
    export HISTFILE="$XDG_STATE_HOME"/bash/history
    export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
    export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/pythonrc
    export LESSHISTFILE="$XDG_STATE_HOME"/less/history
    export CALCHISTFILE="$XDG_CACHE_HOME"/calc_history
    
    # Data directories
    export ANDROID_USER_HOME="$XDG_DATA_HOME"/android
    export ANDROID_HOME="$XDG_DATA_HOME"/android/sdk
    export CARGO_HOME="$XDG_DATA_HOME"/cargo
    export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
    export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
    export WINEPREFIX="$XDG_DATA_HOME"/wine
    #export GNUPGHOME="$XDG_DATA_HOME"/gnupg
    export GOPATH="$XDG_DATA_HOME"/go
    export W3M_DIR="$XDG_DATA_HOME"/w3m
    export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel
    export XCURSOR_PATH=${XCURSOR_PATH}:"$XDG_DATA_HOME"/icons
    
    # Config files/directories
    export ZDOTDIR=$XDG_CONFIG_HOME/zsh
    export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
    export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
    export SCREENRC="$XDG_CONFIG_HOME"/screen/screenrc
    export DOT_SAGE="$XDG_CONFIG_HOME"/sage
    export BN_USER_DIRECTORY="$XDG_CONFIG_HOME"/binaryninja
    export PF_SOURCE="$XDG_CONFIG_HOME"/pfetchrc
    export FZF_DEFAULT_OPTS_FILE="$XDG_CONFIG_HOME"/fzfrc
    export WGETRC="$XDG_CONFIG_HOME"/wgetrc
    
# Program options

    # Enable wrap-around instead of truncating text when using journalctl
    export SYSTEMD_LESS=FRXMK

    # man
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export MANROFFOPT="-c" # fix formatting issues

    # less
    export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
    export LESS='-R '

    # Necessary for ssh-agent
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR"/ssh-agent.socket

    # Disable git filter-branch warning
    export FILTER_BRANCH_SQUELCH_WARNING=1

    # Java
    export JAVA_HOME=/usr/lib/jvm/default

    # GPG key: https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits
    export GPG_TTY=$(tty)

