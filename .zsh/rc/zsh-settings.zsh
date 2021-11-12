bindkey -e

# コマンド単位の移動
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey \^U backward-kill-line

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

# Ctrl+U の動きを bash に揃える
bindkey \^U backward-kill-line

## git command replace to hub
if which hub > /dev/null; then function git(){hub "$@"}; fi
