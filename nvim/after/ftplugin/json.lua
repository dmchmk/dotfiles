vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.json",
  callback = function()
    -- vim.cmd([[%!jq . 2>/dev/null || cat]])
    vim.cmd([[%!jq . ]])
  end,
})
