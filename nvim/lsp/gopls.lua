return {
  cmd = { "/home/dmchumak/.ya/tools/v3/gopls-linux/gopls" },
  filetypes = { "go", "gotempl", "gowork", "gomod" },
  root_markers = { "ya.make", "YAOWNERS", ".arcadia.root", ".cloudia.root", "go.work", "go.mod", ".git" },
  -- settings = {
  --   gopls = {
  --     completeUnimported = true,
  --     usePlaceholders = true,
  --     analyses = {
  --       unusedparams = true,
  --     },
  --     ["ui.inlayhint.hints"] = {
  --       compositeLiteralFields = true,
  --       constantValues = true,
  --       parameterNames = true,
  --       rangeVariableTypes = true,
  --     },
  --   },
  -- },
}
