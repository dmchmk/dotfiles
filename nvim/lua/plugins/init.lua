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
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('github-theme').setup({
        -- ...
      })

      -- vim.cmd('colorscheme github_light_colorblind')
      -- vim.cmd('colorscheme github_light')
      vim.cmd('colorscheme github_dark_colorblind')
      -- vim.cmd('colorscheme github_dark')
    end,
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
  {
    "olimorris/codecompanion.nvim",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "yetone/avante.nvim",
    build = vim.fn.has("win32") ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      provider = "yadeepseek",
      providers = {
        yadeepseek = {
          __inherited_from = "openai",
          api_key_name = "cmd:cat ~/.config/eliza_api_key",
          endpoint = "https://api.eliza.yandex.net/raw/internal/deepseek/v1",
          model = "deepseek-0324",
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua",              -- for file_selector provider fzf
      -- "stevearc/dressing.nvim",        -- for input provider dressing
      -- "folke/snacks.nvim",             -- for input provider snacks
      -- "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
    },
  }
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
require("plugins/codecompanion")
