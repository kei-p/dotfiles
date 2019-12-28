export ZPLUG_HOME=${HOME}/.zsh/zplug
source ${ZPLUG_HOME}/init.zsh

source $HOME/dotfiles/zshrc/zsh_settings.zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-completions"
zplug "b4b4r07/enhancd", use:init.sh

ENHANCD_FILTER=peco
export ENHANCD_FILTER

# 未インストール項目をインストールする
if ! zplug check; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# コマンドをリンクして、PATH に追加し、プラグインは読み込む
zplug load

if (which zprof > /dev/null 2>&1) ;then
  zprof
fi
