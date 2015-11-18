VIM_BUNDLE=$DOTFILES_DIR/.vim/bundle

# install neobundle
if [ ! -e $VIM_BUNDLE/neobundle.vim ]; then
  git clone https://github.com/Shougo/neobundle.vim.git $VIM_BUNDLE/neobundle.vim

  git clone https://github.com/Shougo/vimproc.vim.git $VIM_BUNDLE/vimproc.vim
  (cd $VIM_BUNDLE/vimproc.vim && make)

  ## Neobundleの実行
  $VIM_BUNDLE/neobundle.vim/bin/neoinstall
fi

