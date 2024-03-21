" vim-plug example
"call plug#begin('~/.vim/bundle')
"Plug 'pearofducks/ansible-vim'
"call plug#end()

let g:ansible_goto_role_paths = './roles,../_common/roles'

function! FindAnsibleRoleUnderCursor()
  echo "test!"
  if exists("g:ansible_goto_role_paths")
    let l:role_paths = g:ansible_goto_role_paths
  else
    let l:role_paths = "./roles"
  endif
  let l:tasks_main = expand("<cfile>") . "/tasks/main.yml"
  let l:found_role_path = findfile(l:tasks_main, l:role_paths)
  if l:found_role_path == ""
    echo l:tasks_main . " not found"
  else
    execute "edit " . fnameescape(l:found_role_path)
  endif
endfunction

nnoremap <leader>gd :call FindAnsibleRoleUnderCursor()<CR>
vnoremap <leader>gd :call FindAnsibleRoleUnderCursor()<CR>
