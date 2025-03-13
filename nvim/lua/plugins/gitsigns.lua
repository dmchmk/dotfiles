require('gitsigns').setup(
  {
    signs = {
      add          = { text = '+' },
      change       = { text = '~' },
      delete       = { text = '-' },
      topdelete    = { text = '▀' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged = {
      add          = { text = '+' },
      change       = { text = '~' },
      delete       = { text = '-' },
      topdelete    = { text = '▀' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
  }
)

vim.keymap.set('n', '<leader>vb', ':Gitsigns blame_line<CR>', {desc = "Blame current line (git/arc)"})
