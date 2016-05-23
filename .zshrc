#!/bin/zsh

bindkey -e

# コマンド単位の移動
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

## zsh settings
setopt share_history      # historyの共有
setopt auto_pushd         # cdするたびpushd
setopt pushd_ignore_dups  # pushd時の重複を無視
setopt ignore_eof         # ^Dでログアウトを無効化

## History
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=10000
setopt hist_ignore_dups     # 履歴の重複を記録しない
setopt hist_ignore_all_dups # 重複した際に古いものを削除
setopt hist_ignore_space    # スペースで始まるコマンド行はヒストリリストから削除
setopt hist_no_store        # history自身は記録しない
function history-all { history -E 1 }

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

## git command replace to hub
if which hub > /dev/null; then function git(){hub "$@"}; fi

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

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
