-- Enable fast loader — put this in init.lua as the VERY FIRST line instead
-- (shown here for clarity)
vim.loader.enable()

require("plugins.ui")
require("plugins.snacks")
require("plugins.editor")
require("plugins.lsp")
require("plugins.git")
require("plugins.tools")
-- Language plugins only load on filetype, so they're cheap to always require
require("plugins.lang.rust")
require("plugins.lang.typescript")
require("plugins.lang.python")
require("plugins.lang.cpp")
require("plugins.lang.typst")

vim.pack.add({
  -- LSP server installer (still useful for binary management)
  { src = "https://github.com/mason-org/mason.nvim" },

  -- Completion (optional if using native autocomplete)
  -- { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },

  -- Fuzzy finder
  -- { src = "https://github.com/ibhagwan/fzf-lua" },

  -- Git signs in gutter
  { src = "https://github.com/lewis6991/gitsigns.nvim" },

  -- Git commands
  -- { src = "https://github.com/tpope/vim-fugitive" },

  -- Colorscheme (swap for your preference)
  -- { src = "https://github.com/folke/tokyonight.nvim" },
})

-- Setup calls after vim.pack.add
require("mason").setup({})
require("gitsigns").setup({})
-- require("fzf-lua").setup({ winopts = { backdrop = 85 } })
-- vim.cmd.colorscheme("tokyonight-night")
