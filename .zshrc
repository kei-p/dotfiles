export ZPLUG_HOME=${HOME}/.zsh/zplug
source ${ZPLUG_HOME}/init.zsh
LOCAL_ZSHRC_DIR=${HOME}/dotfiles/zshrc

zplug "${LOCAL_ZSHRC_DIR}/zsh-settings.zsh", from:local
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-completions"
zplug "olivierverdier/zsh-git-prompt", use:zshrc.sh
zplug "b4b4r07/enhancd", use:init.sh
zplug romkatv/powerlevel10k, as:theme, depth:1

export ENHANCD_FILTER=peco

# 未インストール項目をインストールする
if ! zplug check; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# コマンドをリンクして、PATH に追加し、プラグインは読み込む
zplug load

# prompt の設定
source "${LOCAL_ZSHRC_DIR}/p10k.zsh"

# iterm2 prompt
precmd() {
  echo -ne "\033]0;$(pwd | sed -e "s;$HOME\/;~/;g")\007"
}

if (which zprof > /dev/null 2>&1) ;then
  zprof
fi
