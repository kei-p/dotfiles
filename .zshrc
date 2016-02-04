#!/bin/zsh

# コマンド単位の移動
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

## zsh settings
setopt share_history      # historyの共有
setopt auto_pushd         # cdするたびpushd
setopt pushd_ignore_dups  # pushd時の重複を無視
setopt ignore_eof         # ^Dでログアウトを無効化
setopt hist_ignore_space  # スペースで始まるコマンド行はヒストリリストから削除

# コマンド補完の設定
autoload -U compinit
compinit -u

# autoload predict-on
# predict-on

## command history
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
# コマンド検索でCtr-sが使えるようにする
stty stop undef
stty start undef

# git Prompt Setting
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWSTASHSTATE=1
source ~/.zsh/git-prompt.sh
function git(){hub "$@"}

## Prompt
setopt prompt_subst
PROMPT=\
'%n %F{blue}%c %F{red}$(__git_ps1 "[%s] ")
%F{black}$ %f'
RPROMPT='%F{green}[%*]%f'

## iterm2 prompt
precmd() {
  echo -ne "\033]0;$(pwd | sed -e "s;$HOME\/;~/;g")\007"
}

## antigen
if [[ -f $HOME/.zsh/antigen/antigen.zsh ]]; then
  source $HOME/.zsh/antigen/antigen.zsh
  antigen bundle zsh-users/zsh-syntax-highlighting
  antigen bundle zsh-users/zsh-completions src
  antigen bundle b4b4r07/enhancd
  antigen apply

  # enhancd
  ENHANCD_FILTER=peco; export ENHANCD_FILTER
fi

# direnv
if which direnv > /dev/null; then eval "$(direnv hook zsh)"; fi
