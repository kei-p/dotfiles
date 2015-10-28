if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  au! BufRead,BufNewFile *.java,*xml :call NoExpandTab()
augroup END

function NoExpandTab ()
  set noexpandtab
  set tabstop=4
  set shiftwidth=4
  set softtabstop=4
endfunction
