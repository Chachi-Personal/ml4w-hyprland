-- Which-key
vim.pack.add({ "https://github.com/folke/which-key.nvim" })
require("which-key").setup({})
vim.keymap.set({ "n" }, "<leader>?", function()
	require("which-key").show({ gloabl = false })
end, { desc = "Buffer Local Keymaps (which-key)" })
