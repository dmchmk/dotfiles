vim.g.mapleader = " "
vim.keymap.set("n", "<space><space>", "<cmd> :noh<CR>", { desc = "Clear search highlighting" })

-- Find and replace visual selection using CTRL-r
vim.keymap.set("v", "<C-r>", "\"hy:%s/<C-r>h//gc<left><left><left>")
