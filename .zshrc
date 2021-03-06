source "${HOME}/dotfiles/.zsh/zplugin/zplugin.zsh"

autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

export LOCAL_ZSHRC_DIR=${HOME}/dotfiles/.zsh/rc
source "${LOCAL_ZSHRC_DIR}/init.zsh"

zplugin load "${LOCAL_ZSHRC_DIR}/zsh-settings.zsh"
zplugin light "zsh-users/zsh-syntax-highlighting"
zplugin light "zsh-users/zsh-completions"
zplugin load "b4b4r07/enhancd"
zplugin atload"!source ${LOCAL_ZSHRC_DIR}/p10k.zsh" lucid nocd
zplugin light "romkatv/powerlevel10k"
zplugin atload"!source ${LOCAL_ZSHRC_DIR}/anyframe.zsh" lucid nocd
zplugin light "mollifier/anyframe"

export ENHANCD_FILTER=peco

# Ctrl+U の動きを bash に揃える
bindkey \^U backward-kill-line

# iterm2 prompt
precmd() {
  echo -ne "\033]0;$(pwd | sed -e "s;$HOME\/;~/;g")\007"
}

if (which zprof > /dev/null 2>&1) ;then
  zprof
fi
