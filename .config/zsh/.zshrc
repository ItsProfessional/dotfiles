# Launch tmux (only in terminal emulators, not in a tty; also excludes vscode's integrated terminal as it's sometimes buggy with tmux)
if [[ "$(tty)" != "/dev/tty"* ]] && [ -z "$TMUX" ] && [[ "$TERM_PROGRAM" != "vscode" ]]; then
  exec tmux
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# History in cache directory
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=$XDG_CACHE_HOME/zsh/history

# Options
unsetopt menu_complete
unsetopt flowcontrol
setopt prompt_subst
setopt always_to_end
setopt append_history
setopt auto_menu
setopt complete_in_word
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history
setopt interactivecomments
setopt auto_cd
setopt globdots

# Use menu selection for auto complete
zstyle ':completion:*' menu select

# Enable case-insensitive path completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Plugins
source $XDG_CONFIG_HOME/zsh/catppuccin/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh

# Tab completion
autoload -Uz compinit && compinit

# Plugin options
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Source aliases and functions
[ -f "${XDG_CONFIG_HOME}/zsh/functions" ] && source "${XDG_CONFIG_HOME}/zsh/functions"
[ -f "${XDG_CONFIG_HOME}/zsh/aliases" ] && source "${XDG_CONFIG_HOME}/zsh/aliases"

# Remove duplicates from path
typeset -U path

# Initialize stuff
eval $(thefuck --alias)
eval "$(zoxide init zsh)"

# Fix Ctrl+L not fully clearing history in tmux
if [ ! -z "$TMUX" ]; then
  clear-scrollback-and-screen () {
    zle clear-screen
    tmux clear-history
  }

  zle -N clear-scrollback-and-screen
  bindkey -v '^L' clear-scrollback-and-screen
fi


# Bindings

# Terminal file manager (lf)
bindkey -s '^o' 'lf\n'

# zoxide interactive
#bindkey -s '^i' 'zi\n'

# history substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# beginning and end of line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# fix ctrl+backspace and ctrl+delete
bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word

# fix home/end/delete
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

# fix ctrl+left/right
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# vi mode
bindkey -v
export KEYTIMEOUT=1

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






# https://dev.to/equiman/reveal-the-command-behind-an-alias-with-zsh-4d96
local cmd_alias=""

# Reveal Executed Alias
alias_for() {
  [[ $1 =~ '[[:punct:]]' ]] && return
  local search=${1}
  local found="$( alias $search )"
  if [[ -n $found ]]; then
    found=${found//\\//} # Replace backslash with slash
    found=${found%\'} # Remove end single quote
    found=${found#"$search="} # Remove alias name
    found=${found#"'"} # Remove first single quote
    echo "${found} ${2}" | xargs # Return found value (with parameters)
  else
    echo ""
  fi
}

expand_command_line() {
  first=$(echo "$1" | awk '{print $1;}')
  rest=$(echo ${${1}/"${first}"/})

  if [[ -n "${first//-//}" ]]; then # is not hypen
    cmd_alias="$(alias_for "${first}" "${rest:1}")" # Check if there's an alias for the command
    if [[ -n $cmd_alias ]] && [[ "${cmd_alias:0:1}" != "." ]]; then # If there was and not start with dot
      echo "${T_GREEN}❯ ${T_YELLOW}${cmd_alias}${F_RESET}" # Print it
    fi
  fi
}

pre_validation() {
  [[ $# -eq 0 ]] && return                    # If there's no input, return. Else...
  expand_command_line "$@"
}

#autoload -U add-zsh-hook
#add-zsh-hook preexec pre_validation

# Atuin
eval "$(atuin init zsh --disable-up-arrow)"

# powerlevel10k
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
