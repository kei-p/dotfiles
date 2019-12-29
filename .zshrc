source "${HOME}/dotfiles/.zsh/zplugin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

LOCAL_ZSHRC_DIR=${HOME}/dotfiles/zshrc

zplugin load "${LOCAL_ZSHRC_DIR}/zsh-settings.zsh"
zplugin light "zsh-users/zsh-syntax-highlighting"
zplugin light "zsh-users/zsh-completions"
zplugin load "b4b4r07/enhancd"
zplugin light "romkatv/powerlevel10k"

export ENHANCD_FILTER=peco

# prompt の設定
source "${LOCAL_ZSHRC_DIR}/p10k.zsh"

# iterm2 prompt
precmd() {
  echo -ne "\033]0;$(pwd | sed -e "s;$HOME\/;~/;g")\007"
}

if (which zprof > /dev/null 2>&1) ;then
  zprof
fi
