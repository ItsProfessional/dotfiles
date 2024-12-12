# Launch tmux (only in terminal emulators, not in a tty; also excludes vscode's integrated terminal as it's sometimes buggy with tmux)
# if [[ "$(tty)" != "/dev/tty"* ]] && [ -z "$TMUX" ] && [[ "$TERM_PROGRAM" != "vscode" ]]; then
  # exec tmux
# fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  # source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# For MacOS homebrew
if [ -f "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Powerlevel10k
#zinit ice depth=1; zinit light romkatv/powerlevel10k

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light kutsan/zsh-system-clipboard
zinit light Aloxaf/fzf-tab
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found
zinit snippet https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/refs/heads/main/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh

# Options
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# Keybindings
export KEYTIMEOUT=1
bindkey -v
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^n' history-search-forward
bindkey '^p' history-search-backward
bindkey '^[w' kill-region

bindkey -M vicmd j history-search-forward
bindkey -M vicmd k history-search-backward

bindkey '^[[A' history-search-backward # Up
bindkey '^[[B' history-search-forward # Down
bindkey "^[[H" beginning-of-line # Home
bindkey "^[[F" end-of-line # End
bindkey "^[[3~" delete-char # Delete
bindkey "^[[1;5C" forward-word # C-Right
bindkey "^[[1;5D" backward-word # C-Left
bindkey '^H' backward-kill-word # C-Backspace
bindkey '^[[3;5~' kill-word # C-Delete

bindkey -s '^o' 'lf\n'

# Fix Ctrl+L not fully clearing history in tmux
if [ ! -z "$TMUX" ]; then
  clear-scrollback-and-screen () {
    zle clear-screen
    tmux clear-history
  }

  zle -N clear-scrollback-and-screen
  bindkey -v '^L' clear-scrollback-and-screen
fi

# History
HISTSIZE=10000
HISTFILE=$XDG_CACHE_HOME/zsh/history
SAVEHIST=$HISTSIZE
HISTDUP=erase

unsetopt menu_complete
unsetopt flowcontrol
setopt prompt_subst
setopt always_to_end
setopt auto_menu
setopt complete_in_word
setopt append_history
setopt inc_append_history
setopt share_history
setopt extended_history
setopt hist_ignore_space
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_verify
setopt interactivecomments
setopt auto_cd
setopt globdots

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[6 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[6 q"
}
zle -N zle-line-init
echo -ne '\e[6 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[6 q' ;} # Use beam shape cursor for each new prompt.

# Source
[ -f "${XDG_CONFIG_HOME}/zsh/aliases" ] && source "${XDG_CONFIG_HOME}/zsh/aliases"
[ -f "${XDG_CONFIG_HOME}/zsh/functions" ] && source "${XDG_CONFIG_HOME}/zsh/functions"

# Shell integrations
#eval "$(starship init zsh)"
eval "$(oh-my-posh init zsh --config $XDG_CONFIG_HOME/ohmyposh/base.toml)"
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(thefuck --alias)"
eval "$(batman --export-env)"

