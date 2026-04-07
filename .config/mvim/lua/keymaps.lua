local map = vim.keymap.set

-- Navigation
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Make cursor stay in palce when concattinating with J
map("n", "J", "mzJ`z")

-- Commenting
map("n", "<C-_>", "gcc", { remap = true })
map("n", "<C-/>", "gcc", { remap = true })
map("v", "<C-_>", "gc", { remap = true })
map("n", "<C-/>", "gc", { remap = true })

-- Files
map("n", "<leader>-", "<cmd>Ex %:p:h<CR>", { silent = true, desc = "Netrw" }) -- Netrw

-- Plugin management (vim.pack)
map("n", "<leader>pu", "<cmd>lua vim.pack.update()<CR>", { silent = true, desc = "Update plugins" })

-- LSP (0.12 provides gra/grn/grr/gri by default, add extras here)

-- -- Don't set clipboard globally; instead map y explicitly
-- map({ "n", "v" }, "y", '"+y', { noremap = true })
-- map("n", "yy", '"+yy', { noremap = true })
-- map("n", "Y", '"+Y', { noremap = true })
-- -- p still pastes from system clipboard
-- map({ "n", "v" }, "p", '"+p', { noremap = true })
-- map({ "n", "v" }, "P", '"+P', { noremap = true })
