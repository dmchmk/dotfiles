vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
-- Set up nvim-cmp
local cmp = require('cmp')
local luasnip = require('luasnip')
local select_opts = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  window = {
    documentation = cmp.config.window.bordered(),
    completion = { border = 'rounded' }
  },
  formatting = {
    fields = { 'menu', 'abbr', 'kind' },
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = '🖫',
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  mapping = {
    -- Trigger completion menu with <Tab>
    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, { 'i', 's' }),

    -- Trigger completion menu with <C-Space>
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }), -- Open completion menu

    -- Navigate completion menu with <C-n> and <C-p>
    ['<C-n>'] = cmp.mapping.select_next_item(), -- Next item
    ['<C-p>'] = cmp.mapping.select_prev_item(), -- Previous item

    -- Confirm selection with <CR> (Enter)
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- LSP source
    { name = 'buffer' },   -- Buffer source
    { name = 'path' },     -- Path source
    { name = 'luasnip' },  -- Path source
  }),
})
