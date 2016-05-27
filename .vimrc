scriptencoding utf-8

if has('vim_starting')
  filetype plugin off
  filetype indent off
  execute 'set runtimepath+=' . expand('~/.vim/bundle/neobundle.vim')
  execute 'set runtimepath+=' . expand('~/.vim/bundle/vimproc.vim')
endif

set nocompatible
set backspace=start,eol,indent

set number
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set hlsearch
set incsearch

" 特殊記号の表示変更
set list
set listchars=tab:>\ ,eol:$

" SSH クライアントの設定によってはマウスが使える（putty だと最初からいける
set mouse=n
" これをしないと候補選択時に Scratch ウィンドウが開いてしまう
set completeopt=menuone

"" ショートカット
" 移動系
nnoremap <Down> gj
nnoremap <Up> gk
nnoremap <C-Down> G
nnoremap <C-Up> gg
nnoremap <C-Right> $
nnoremap <C-Left> <S-0>

" バッファーの切り替え
noremap <silent> [b :bprevious<CR>
noremap <silent> ]b :bnext<CR>
noremap <silent> [B :bfirst<CR>
noremap <silent> ]B :bprevious<CR>

" 文字列検索のハイライト制御
nnoremap / :<C-u>set hlsearch<Return>/
nnoremap ? :<C-u>set hlsearch<Return>?
nnoremap * :<C-u>set hlsearch<Return>*
nnoremap # :<C-u>set hlsearch<Return>#
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" Unite.vim bufferの起動
nnoremap <C-h> :Unite file_mru<CR>

" 連続コピペ
vnoremap <silent> <C-p> "0p

" Leader
let mapleader = "\<Space>"
nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>" :reg<CR>
nnoremap <Leader>b :ls<CR>
nnoremap <Leader>` :marks<CR>

" clipboard へ ヤンク/ペースト
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" visualモードから検索
function! s:VSetSearch()
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s = temp
endfunction
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>

"" Quickfix
" grepでcwindowを自動起動
autocmd QuickFixCmdPost *grep* cwindow
function! s:ToggleQuickFixWindow()
  let _ = winnr('$')
  cclose
  if _ == winnr('$')
    copen
  endif
endfunction
nnoremap <silent> <C-q> :<C-u>call <SID>ToggleQuickFixWindow()<CR>

" quickfixを自動的に閉じる
function s:QuickFixExitIfOnlyCWindow()
  if winnr('$') == 1
    if (getbufvar(winbufnr(0), '&buftype')) == 'quickfix'
      quit
    endif
  endif
endfunction
autocmd WinEnter * call s:QuickFixExitIfOnlyCWindow()

nnoremap <silent> <C-m> :cnext<CR>
nnoremap <silent> <C-n> :cprevious<CR>

" 待機中のカーソル行をハイライト
augroup vimrc-auto-cursorline
  autocmd!
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')

  let s:cursorline_lock = 0
  function! s:auto_cursorline(event)
    if a:event ==# 'WinEnter'
      setlocal cursorline
      let s:cursorline_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorline
    elseif a:event ==# 'CursorMoved'
      if s:cursorline_lock
        if 1 < s:cursorline_lock
          let s:cursorline_lock = 1
        else
          setlocal nocursorline
          let s:cursorline_lock = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      setlocal cursorline
      let s:cursorline_lock = 1
    endif
  endfunction
augroup END

" vim練習用オプション
if $VIM_TRAINEE
  "" 矢印無効化
  noremap <Down> <Nop>
  noremap <Up> <Nop>
  noremap <Right> <Nop>
  noremap <Left> <Nop>
endif


"" NeoBundle
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundle 'kien/ctrlp.vim.git'
NeoBundle 'Shougo/neobundle.vim.git'
NeoBundle 'scrooloose/nerdtree.git'
NeoBundle 'scrooloose/syntastic.git'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'tpope/vim-rails'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'tyru/caw.vim.git'
NeoBundle 'cocopon/colorswatch.vim'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'tomasr/molokai'
NeoBundle 'tpope/vim-surround'
NeoBundle 'bronson/vim-trailing-whitespace'
NeoBundle 'jacquesbh/vim-showmarks'
NeoBundle 'mtth/scratch.vim'
NeoBundle 'tpope/vim-fugitive.git'
NeoBundle 'kchmck/vim-coffee-script'
call neobundle#end()

"" colorscheme
let g:rehash256 = 1
colorscheme molokai
colorscheme custom
syntax on

"" NERDTree
autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let g:NERDTreeIgnore=['\.clean$', '\.swp$', '\.bak$', '\~$']
" <C-e>でNERDTreeをオンオフ いつでもどこでも
nmap <silent> <C-e>      :NERDTreeToggle<CR>
vmap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
omap <silent> <C-e>      :NERDTreeToggle<CR>
imap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
cmap <silent> <C-e> <C-u>:NERDTreeToggle<CR>

"" Neocomplecache settings
let g:neocomplcache_enable_at_startup = 1

"" vim-indent-guides
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=4
let g:indent_guides_auto_colors=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermfg=241 ctermbg=236
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermfg=241 ctermbg=237

"" caw
map <C-c> <Plug>(caw:i:toggle)

"" lightline
set laststatus=2
set guifont=Ricty-RegularForPowerline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'inactive': {
      \   'right': [  ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"⭤":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}'
      \ }
      \ }

"" vim-showmarks
aug show-marks-sync
  au!
  au BufReadPost * sil! DoShowMarks
aug END

"" matchit
runtime macros/matchit.vim


filetype plugin on
filetype indent on
