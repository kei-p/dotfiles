#!/bin/sh

current_dir=$(cd $(dirname $0) && pwd)

symlink_dotfile () {
  dotfile_name=$1

  symlink_path="$HOME/.${dotfile_name}"
  dotfile_path=$current_dir/$dotfile_name

  if [ ! -e "$symlink_path" ]; then
    ln -s $dotfile_path $symlink_path
  elif [ -e "$symlink_path" -a ! "$(readlink $symlink_path)" = $dotfile_path ]; then
    echo "[Error] ${symlink_path} is already exist. If you use this settings, Please delete it."
    exit 1
  fi
}


### zsh
symlink_dotfile "zsh"
symlink_dotfile "zshrc"

if [ ! -e zsh/antigen/antigen.zsh ]; then
  git clone https://github.com/zsh-users/antigen.git zsh/antigen
fi



### vim
symlink_dotfile "vim"
symlink_dotfile "vimrc"

VIM_BUNDLE="vim/bundle"
if [ ! -e $VIM_BUNDLE/neobundle.vim ]; then
  git clone https://github.com/Shougo/neobundle.vim.git $VIM_BUNDLE/neobundle.vim
fi

if [ ! -e $VIM_BUNDLE/vimproc.vim ]; then
  git clone https://github.com/Shougo/vimproc.vim.git $VIM_BUNDLE/vimproc.vim
  (cd $VIM_BUNDLE/vimproc.vim && make)
fi

## Neobundleの実行
$VIM_BUNDLE/neobundle.vim/bin/neoinstall
