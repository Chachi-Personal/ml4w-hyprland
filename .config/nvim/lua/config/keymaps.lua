local map = vim.keymap.set

-- ─── General ──────────────────────────────────────────────────────────────────

-- Plugin management (vim.pack)
map("n", "<leader>pu", "<cmd>lua vim.pack.update()<CR>", { silent = true, desc = "Update plugins" })

map("n", "<leader>R", function()
	local old = vim.fn.expand("%")
	local new = vim.fn.input("Rename: ", old)
	if new ~= "" and new ~= old then
		vim.cmd("saveas " .. new)
		vim.cmd("silent! !rm " .. old)
		vim.cmd("redraw!")
	end
end, { desc = "Rename file" })

-- Make cursor stay in palce when concattinating with J
map("n", "J", "mzJ`z")

-- Comments
map("n", "<C-_>", "gcc", { remap = true })
map("n", "<C-/>", "gcc", { remap = true })
map("v", "<C-_>", "gc", { remap = true })
map("v", "<C-/>", "gc", { remap = true })

-- Navigation
-- map("n", "<C-d>", "<C-d>zz")
-- map("n", "<C-u>", "<C-u>zz")

-- Splits
-- map("n", "|",  "<Cmd>vsplit<CR>", { desc = "Vertical split" })
-- map("n", "\\", "<Cmd>split<CR>",  { desc = "Horizontal split" })

-- ─── Diagnostics / quickfix ───────────────────────────────────────────────────
map("n", "<leader>xq", "<Cmd>copen<CR>", { desc = "Quickfix list" })
map("n", "<leader>xl", "<Cmd>lopen<CR>", { desc = "Location list" })

-- ─── Diagnostics (global — no LSP needed) ────────────────────────────────────
map("n", "gl", vim.diagnostic.open_float, { desc = "Hover diagnostics" })
map("n", "[e", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Previous error" })
map("n", "]e", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })
map("n", "[w", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
end, { desc = "Previous warning" })
map("n", "]w", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
end, { desc = "Next warning" })

-- ─── Buffers ──────────────────────────────────────────────────────────────────
map("n", "]b", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "[b", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bp", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>c", "<Cmd>bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>C", "<Cmd>bdelete!<CR>", { desc = "Force close buffer" })
map("n", "<leader>bc", function() -- close all except current
	local cur = vim.fn.bufnr()
	for _, b in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
		if b.bufnr ~= cur then
			vim.cmd("bdelete " .. b.bufnr)
		end
	end
end, { desc = "Close all except current" })
map("n", "<leader>bC", "<Cmd>%bdelete<CR>", { desc = "Close all buffers" })

-- ─── Tabs ─────────────────────────────────────────────────────────────────────
map("n", "]t", "<Cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "[t", "<Cmd>tabprevious<CR>", { desc = "Previous tab" })

-- ─── Window navigation (plain — use smart-splits if you add that plugin) ──────
map("n", "<C-H>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-J>", "<C-w>j", { desc = "Move to below split" })
map("n", "<C-K>", "<C-w>k", { desc = "Move to above split" })
map("n", "<C-L>", "<C-w>l", { desc = "Move to right split" })
map("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Resize split up" })
map("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Resize split down" })
map("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Resize split left" })
map("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Resize split right" })

-- Terminal window nav
map("t", "<C-H>", "<Cmd>wincmd h<CR>", { desc = "Terminal left" })
map("t", "<C-J>", "<Cmd>wincmd j<CR>", { desc = "Terminal down" })
map("t", "<C-K>", "<Cmd>wincmd k<CR>", { desc = "Terminal up" })
map("t", "<C-L>", "<Cmd>wincmd l<CR>", { desc = "Terminal right" })
