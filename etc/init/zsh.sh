## install antigen
if [ -e $DOTFILES_DIR/.zsh/antigen ]; then
  rm -rf $DOTFILES_DIR/.zsh/antigen
fi

git clone https://github.com/zsh-users/antigen.git $DOTFILES_DIR/.zsh/antigen
