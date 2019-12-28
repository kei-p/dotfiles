## install zplug
if [ -e $DOTFILES_DIR/.zsh/zplug ]; then
  rm -rf $DOTFILES_DIR/.zsh/zplug
fi

git clone https://github.com/zplug/zplug.git $DOTFILES_DIR/.zsh/zplug
