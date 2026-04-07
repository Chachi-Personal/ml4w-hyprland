local defer = vim.schedule -- shorthand for deferred loading

-- Colorscheme — must load eagerly
vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })
vim.cmd.colorscheme("tokyonight-night")

-- Transparent background
vim.pack.add({ "https://github.com/xiyaowong/transparent.nvim" })
require("transparent").setup({ extra_groups = { "NormalFloat" } })

-- Icons (needed by many plugins — load eagerly)
vim.pack.add({ "https://github.com/echasnovski/mini.icons" })
require("mini.icons").setup({})

-- Noice — deferred (was VeryLazy)
defer(function()
  vim.pack.add({
    "https://github.com/MunifTanjim/nui.nvim",
    "https://github.com/folke/noice.nvim",
  })
  require("noice").setup({
    lsp = { override = { ["vim.lsp.util.convert_input_to_markdown_lines"] = true } },
    presets = { bottom_search = true, command_palette = true },
  })
end)

-- Highlight colors (#0ff, rgb(), etc.) — on file open
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("LazyLoad_Colors", { clear = true }),
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/brenoprata10/nvim-highlight-colors" })
    require("nvim-highlight-colors").setup({ render = "background" })
  end,
})

-- Statusline: use heirline or a lightweight built-in statusline
-- heirline is heavy; consider replacing with a hand-rolled statusline
-- in lua/statusline.lua using set statusline= for a truly minimal setup.
-- If you want to keep heirline:
-- defer(function()
--   vim.pack.add({ "https://github.com/rebelot/heirline.nvim" })
--   -- your heirline config here
-- end)
