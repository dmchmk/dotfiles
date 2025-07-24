require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    'lua_ls',
    'gopls',
    'bashls',
    'basedpyright',
  },
  automatic_installation = true,
  automatic_enable = false
})

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local bufnr = ev.buf
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    local lsp = vim.lsp
    local function opt(desc, others)
      return vim.tbl_extend("force", bufopts, { desc = desc }, others or {})
    end

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    keymap("n", "gD", lsp.buf.declaration, opt('[G]o to [d]eclaration'))
    keymap("n", "gd", lsp.buf.definition, opt("[G]o to [d]efinition"))
    keymap("n", "<leader>D", lsp.buf.type_definition, opt("Go to Type [D]efinition"))
    keymap("n", "K", lsp.buf.hover, bufopts)
    keymap("n", "gi", lsp.buf.implementation, opt("[G]o to [i]mplementation"))
    keymap("n", "gr", require'telescope.builtin'.lsp_references, opt("[G]o to [r]eferences"))
    keymap("n", "<C-k>", lsp.buf.signature_help, bufopts)
    keymap("n", "<leader>wa", lsp.buf.add_workspace_folder, bufopts)
    keymap("n", "<leader>wr", lsp.buf.remove_workspace_folder, bufopts)
    keymap("n", "<leader>wl", function()
      print(vim.inspect(lsp.buf.list_workspace_folders()))
    end, bufopts)
    keymap("n", "<leader>rn", lsp.buf.rename, opt("[l]sp [R]ename"))
    keymap("n", "<leader>lc", lsp.buf.code_action, opt("[l]sp [C]ode Action"))
    keymap("n", "<leader>lf", function()
      lsp.buf.format({
        async = true,
      })
    end, opt("[l]sp [f]ormat buffer"))
  end
})

-- Add the border on hover and on signature help popup window
vim.o.winborder = 'rounded'

-- Add border to the diagnostic popup window
vim.diagnostic.config({
  virtual_text = {
    prefix = '■ ', -- Could be '●', '▎', 'x', '■', , 
  },
  signs = false, -- Show signs in the gutter
  underline = true,
  update_in_insert = false, -- Don't update diagnostics in insert mode
  severity_sort = true, -- Sort diagnostics by severity
  jump = { float = true },
})

keymap("n", "<leader>e", vim.diagnostic.open_float, opts)
keymap("n", "<leader>q", vim.diagnostic.setloclist, opts)

vim.lsp.enable("lua_ls")
vim.lsp.enable("bashls")
vim.lsp.enable("gopls")
vim.lsp.enable("basedpyright")
