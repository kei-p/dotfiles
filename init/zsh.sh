## install zplug
if [ -e $DOTFILES_DIR/.zsh/zplugin ]; then
  rm -rf $DOTFILES_DIR/.zsh/zplugin
fi

git clone https://github.com/zdharma-continuum/zinit.git $DOTFILES_DIR/.zsh/zinit
