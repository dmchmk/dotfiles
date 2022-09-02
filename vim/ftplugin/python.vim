fu PyRun() range
  echo system('python -c ' . shellescape(join(getline(a:firstline, a:lastline), "\n")))
endf

vmap <F5> :call PyRun()<CR>

