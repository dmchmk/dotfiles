require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    'lua_ls',
    'gopls',
    'bashls',
    'pyright',
  },
  automatic_installation = true,
})

-- Customized on_attach function
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
--
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  if client.name == "rust_analyzer" then
    -- This requires Neovim 0.10 or later
    vim.lsp.inlay_hint.enable()
  end

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, Append(bufopts, "desc", 'Go to declaration'))
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, Append(bufopts, "desc", "Go to definition"))
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, Append(bufopts, "desc", "Go to implementation"))
  vim.keymap.set("n", "gr", require'telescope.builtin'.lsp_references, Append(bufopts, "desc", "Go to references"))
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "<leader>lf", function()
    vim.lsp.buf.format({
      async = true,
    })
  end, bufopts)
end

-- Add the border on hover and on signature help popup window
local handlers = {
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

-- Add border to the diagnostic popup window
vim.diagnostic.config({
  virtual_text = {
    prefix = '■ ', -- Could be '●', '▎', 'x', '■', , 
  },
  signs = false, -- Show signs in the gutter
  underline = true,
  update_in_insert = false, -- Don't update diagnostics in insert mode
  severity_sort = true, -- Sort diagnostics by severity
  float = { border = "rounded" },
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("lspconfig").lua_ls.setup({
  on_attach = on_attach,
  settings = {
    Lua = {
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        }
      },
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    }
  },
  capabilities = capabilities,
  handlers = handlers
})
require("lspconfig").gopls.setup { capabilities = capabilities, handlers = handlers, on_attach = on_attach,
  cmd = IsYandex and { "/home/dmchumak/.ya/tools/v3/gopls-linux/gopls" },
  root_dir = IsYandex and require('lspconfig').util.root_pattern("YAOWNERS", "ya.make", ".arcadia.root", ".cloudia.root", "go.work", "go.mod", ".git"),
  -- settings = {
  --   gopls = {
  --     arcadiaIndexDirs = {
  --       "/home/horseinthesky/bl/cloud-go/cloud/cloud-go/cloudgate",
  --     },
  --   },
  -- },
}
require("lspconfig").bashls.setup { capabilities = capabilities, handlers = handlers,
  on_attach = on_attach,
  settings = {
    bashIde = {
      globPattern = "*@(.sh|.inc|.bash|.command)"
    }
  }
}
require("lspconfig").pyright.setup { capabilities = capabilities, handlers = handlers,
  on_attach = on_attach,
  -- more details on configuring pyright can be found here
  -- https://microsoft.github.io/pyright/#/settings?id=pyright-settings
  settings = {
    python = {
      analysis = {
        include = {
          '~/arcadia',
          '~/arcadia/yt/python',
          '~/arcadia/contrib/libs/protobuf/python',
          '~/arcadia/contrib/python',
        }
      }
    }
  }
}
