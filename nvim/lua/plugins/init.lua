local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  {
    "scottmckendry/cyberdream.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('cyberdream').setup {
        variant = "light",
        colors = {
          bg_highlight = "#e7eaf0",
          light = {
            bg_highlight = "#e7eaf0",
          },
        },
        highlights = {
          StatusLine = { fg = "#f6f8fa", bg = "#5094e4" },
        },
      }
      require('cyberdream').load()
    end
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
  {
    'hrsh7th/nvim-cmp',       -- Auto-completion plugin
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
      'hrsh7th/cmp-buffer',   -- Buffer source for nvim-cmp
      'hrsh7th/cmp-path',     -- Path source for nvim-cmp
      'L3MON4D3/LuaSnip',
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      show_help = false, -- workaround for border glitch https://github.com/folke/which-key.nvim/issues/967#issuecomment-2842309305
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  -- GitSigns
  {
    (not IsYandex) and "lewis6991/gitsigns.nvim" or nil,
    dir = (IsYandex) and "~/arcadia/contrib/tier1/gitsigns.arc.nvim" or nil,
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      outline_window = {
        position = "left",
      }
      -- Your setup opts here
    },
  },
}

require("lazy").setup(plugins)

vim.cmd([[
  set termguicolors
  hi Cursor guifg=red guibg=green
  set guicursor=n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,o:hor50-Cursor/lCursor,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175-Cursor/lCursor
]])
require("plugins/telescope")
require("plugins/completions")
require("plugins/gitsigns")
-- require("plugins/codecompanion")
