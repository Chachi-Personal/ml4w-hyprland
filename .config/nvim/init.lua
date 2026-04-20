vim.loader.enable()
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		target = "cmd",
		pager = { height = 0.5 },
		dialog = { height = 0.5 },
		cmd = { height = 0.5 },
		msg = { height = 0.5, timeout = 4500 },
	},
})

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("core.autocmds")
require("core.keymaps")
require("core.options")

require("lsp")
require("lsp.completion")

require("plugins")
