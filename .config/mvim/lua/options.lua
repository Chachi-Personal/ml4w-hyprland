local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes:1"
opt.termguicolors = true
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.scrolloff = 8
opt.wrap = false
opt.cursorline = true
opt.undofile = true
opt.winborder = "rounded" -- new in 0.12: rounded window borders
opt.hlsearch = false
opt.ignorecase = true
opt.clipboard = "unnamedplus"

-- Native autocomplete (new in 0.12, replaces nvim-cmp for basic use)
opt.completeopt = { "menuone", "popup", "noinsert" }
-- opt.autocomplete = true  -- enable if you want fully native completion

vim.g.mapleader = " "
