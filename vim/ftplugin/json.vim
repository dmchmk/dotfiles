" au! BufRead,BufNewFile *.json set filetype=json
" augroup json_autocmd
"   autocmd!
"   autocmd FileType json set autoindent
"   autocmd FileType json set formatoptions=tcq2l
"   autocmd FileType json set textwidth=78 shiftwidth=2
"   autocmd FileType json set softtabstop=2 tabstop=2
"   autocmd FileType json set expandtab
"   autocmd FileType json set foldmethod=syntax
" augroup END
set conceallevel=0
let g:indentLine_setConceal = 0
autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab
