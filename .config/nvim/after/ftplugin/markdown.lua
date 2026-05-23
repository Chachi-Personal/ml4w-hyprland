vim.opt_local.spell = true
vim.opt_local.spelllang = { "en" }

vim.schedule(function()
	local win = vim.api.nvim_get_current_win()
	vim.wo[win].foldmethod = "expr"
	vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
	vim.wo[win].foldlevel = 99
	vim.wo[win].foldenable = true
	vim.wo[win].foldtext = ""
end)
