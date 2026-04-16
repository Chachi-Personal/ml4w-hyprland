local opt = vim.opt

opt.termguicolors = true

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 10

opt.tabstop = 4
opt.shiftwidth = 4
-- opt.softtabstop = 0 -- default
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false

opt.signcolumn = "yes:1"
opt.winborder = "rounded" -- new in 0.12: rounded window borders
opt.undofile = true

-- Native autocomplete (new in 0.12, replaces nvim-cmp for basic use)
opt.completeopt = { "menuone", "popup", "noinsert" }
-- opt.autocomplete = true  -- enable if you want fully native completion

opt.clipboard:append("unnamedplus")
