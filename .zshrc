source "${HOME}/dotfiles/.zsh/zinit/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

export LOCAL_ZSHRC_DIR=${HOME}/dotfiles/.zsh/rc
source "${LOCAL_ZSHRC_DIR}/init.zsh"

zinit load "${LOCAL_ZSHRC_DIR}/zsh-settings.zsh"
zinit light "zsh-users/zsh-syntax-highlighting"
zinit light "zsh-users/zsh-completions"
zinit load "b4b4r07/enhancd"
zinit ice lucid atload"!source ${LOCAL_ZSHRC_DIR}/p10k.zsh"
zinit light "romkatv/powerlevel10k"
zinit ice lucid atload"!source ${LOCAL_ZSHRC_DIR}/anyframe.zsh"
zinit light "mollifier/anyframe"

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
