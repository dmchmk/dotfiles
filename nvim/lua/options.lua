vim.g.editorconfig = false
IsYandex = Contains({"i113855042", "dmchumak-dev.sas.yp-c.yandex.net"}, vim.fn.hostname())

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- case insensitive search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- show line numbers
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true

-- show trailing whitespace
vim.opt.list = true
vim.opt.listchars = {
  tab = '▏ ',
  multispace = '▏ ',
  trail = '·',
  extends = '…',
  precedes = '…'
}

vim.cmd([[match errorMsg /\s\+$/]])

-- Configuring movement between panes
-- using Ctrl/Cmd-hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Keymap to copy to system buffer
vim.keymap.set('n','<leader>y','"+yy')
vim.keymap.set('v','<leader>y','"+y')

-- Keymap to navigate between tabs
vim.keymap.set('n', 'H', 'gT')
vim.keymap.set('n', 'L', 'gt')

-- Makeing :W and :Q work same as :w and :q
vim.cmd("command! -bar -nargs=* -complete=file -range=% -bang W         <line1>,<line2>write<bang> <args>")
vim.cmd("command! -bar -nargs=* -complete=file -range=% -bang Write     <line1>,<line2>write<bang> <args>")
vim.cmd("command! -bar -nargs=* -complete=file -range=% -bang Wq        <line1>,<line2>wq<bang> <args>")
vim.cmd("command! -bar                                  -bang Q         quit<bang>")
vim.cmd("command! -bar                                  -bang Qall      qall<bang>")
vim.cmd("command! -bar                                  -bang Qa        qall<bang>")
