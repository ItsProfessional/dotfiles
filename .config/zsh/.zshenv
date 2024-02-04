# Reload zsh on USR1 signal: killall -USR1 zsh
# I use this in my ~/scripts/import-env script
#TRAPUSR1() {
  #if [[ -o INTERACTIVE ]]; then
     #exec zsh
  #fi
#}

## Functions
# Path

  pathremove() {
    # Delete path by parts so we can never accidentally remove sub paths
    if [ "$PATH" = "$1" ]; then PATH=""; fi

    PATH=${PATH//":$1:"/":"} # delete any instances in the middle
    PATH=${PATH/#"$1:"/} # delete any instance at the beginning
    PATH=${PATH/%":$1"/} # delete any instance in the at the end
  }

  pathappend() {
    pathremove "$1"
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
      PATH="${PATH:+"$PATH:"}$1"
    fi
  }

  pathprepend() {
    pathremove "$1"
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
      PATH="$1${PATH:+":$PATH"}"
    fi
  }

## Environment
# XDG Base Directory
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_DATA_DIRS=/usr/local/share:/usr/share
export XDG_CONFIG_DIRS=/etc/xdg

# Path
  # Reorder path
  #pathprepend /usr/local/sbin
  #pathprepend /usr/local/bin
  #pathprepend /usr/lib/jvm/default/bin
  #pathprepend /usr/lib/rustup/bin
  #pathprepend "$HOME"/.local/bin

  # Add scripts directories to path
  #pathprepend ~/scripts
  #for _dir in `find ~/scripts/ -mindepth 1 -maxdepth 1 -type d`;
  #do
    #pathprepend $_dir;
  #done

  # Force PATH to be environment
  #export PATH

# Editor
    export VISUAL=nvim
    export EDITOR=nvim
    export DIFFPROG="nvim -d"

# Change dotfile locations
    # History files
    export HISTFILE="${XDG_STATE_HOME}"/bash/history
    export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
    export PYTHONSTARTUP="/etc/python/pythonrc"
    export LESSHISTFILE="$XDG_STATE_HOME"/less/history
    export CALCHISTFILE="$XDG_CACHE_HOME"/calc_history
    
    # Data directories
    export ANDROID_HOME="$XDG_DATA_HOME"/android
    export CARGO_HOME="$XDG_DATA_HOME"/cargo
    export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
    export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
    export WINEPREFIX="$XDG_DATA_HOME"/wine
    #export GNUPGHOME="$XDG_DATA_HOME"/gnupg
    export GOPATH="$XDG_DATA_HOME"/go
    
    # Config files/directories
    export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
    export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
    export SCREENRC="$XDG_CONFIG_HOME"/screen/screenrc
    
# Program options

    # Enable wrap-around instead of truncating text when using journalctl
    export SYSTEMD_LESS=FRXMK

    # Pfetch config
    export PF_SOURCE="$XDG_CONFIG_HOME"/pfetchrc

    # fzf
    export FZF_DEFAULT_OPTS=" \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --preview 'bat --color=always --style=numbers --line-range=:500 {}'"

    # fzf
    export BEMENU_OPTS="--ignorecase --no-cursor --prompt > --border 1 --list 10 --hp 8 \
      --ch 20 --cw 1 \
      --binding vim --vim-esc-exits \
      --fn \"JetbrainsMono 10\" \
      --fb #1e1e2e --ff #94e2d5 --nb #1e1e2e --nf #f5e0dc --tb #1e1e2e --hb #1e1e2e --tf #cba6f7 --hf #89b4fa --nf #f5e0dc --af #f5e0dc --ab #1e1e2e --bdr #45475a"

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

