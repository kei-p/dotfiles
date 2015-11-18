VIM_BUNDLE=$DOTFILES_DIR/.vim/bundle

# install neobundle
if [ -e $VIM_BUNDLE ]; then
  rm -rf $VIM_BUNDLE
fi

git clone https://github.com/Shougo/neobundle.vim.git $VIM_BUNDLE/neobundle.vim

git clone https://github.com/Shougo/vimproc.vim.git $VIM_BUNDLE/vimproc.vim
(cd $VIM_BUNDLE/vimproc.vim && make)

$VIM_BUNDLE/neobundle.vim/bin/neoinstall
