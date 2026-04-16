-- Enable fast loader — put this in init.lua as the VERY FIRST line instead
-- (shown here for clarity)
vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.autocmds")
require("config.keymaps")
require("config.options")

require("plugins")

require("lsp")
require("lsp.completion")
