## Environment
# XDG Base Directory
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
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
    export TERMINAL=foot
    export SHELL=${SHELL:-"/bin/sh"}

# Change dotfile locations
    # History files
    export HISTFILE="$XDG_STATE_HOME"/bash/history
    export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
    export PYTHONSTARTUP="/etc/python/pythonrc"
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
    export XCURSOR_PATH=${XCURSOR_PATH}:"$XDG_DATA_HOME"/icons
    
    # Config files/directories
    export ZDOTDIR=$XDG_CONFIG_HOME/zsh
    export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
    export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
    export SCREENRC="$XDG_CONFIG_HOME"/screen/screenrc
    export DOT_SAGE="$XDG_CONFIG_HOME"/sage
    export BN_USER_DIRECTORY="$XDG_CONFIG_HOME"/binaryninja
    export PF_SOURCE="$XDG_CONFIG_HOME"/pfetchrc

    
# Program options

    # Enable wrap-around instead of truncating text when using journalctl
    export SYSTEMD_LESS=FRXMK

    # fzf
    export FZF_DEFAULT_OPTS=" \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8" #\
    # --preview 'bat --color=always --style=numbers --line-range=:500 {}'"

    # bemenu
    export BEMENU_OPTS="--ignorecase --no-cursor --prompt \">\" --border 1 --hp 8 \
      --ch 20 --cw 1 \
      --fn \"JetbrainsMono 10\" \
      --fb #11111b --ff #94e2d5 --nb #11111b --nf #f5e0dc --tb #11111b --hb #11111b --tf #cba6f7 --hf #89b4fa --nf #f5e0dc --af #f5e0dc --ab #11111b --bdr #45475a \
      --binding vim --vim-esc-exits"

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

