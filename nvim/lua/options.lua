vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- case insensitive search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- show line numbers
vim.opt.number = true
vim.opt.relativenumber = true
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
