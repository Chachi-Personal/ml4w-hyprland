local defer = vim.schedule
local au = vim.api.nvim_create_autocmd
local aug = vim.api.nvim_create_augroup
local map = vim.keymap.set

-- Todo comments — on file open
-- au({ "BufReadPre", "BufNewFile" }, {
--   group = aug("LazyLoad_Todo", { clear = true }),
--   once = true,
--   callback = function()
--     vim.pack.add({ "https://github.com/folke/todo-comments.nvim" })
--     require("todo-comments").setup({})
--   end,
-- })

-- Which-key — deferred
defer(function()
  vim.pack.add({ "https://github.com/folke/which-key.nvim" })
  require("which-key").setup({})
end)

-- Yazi — on command (CmdUndefined lazy load)
au("CmdUndefined", {
  group = aug("LazyLoad_Yazi", { clear = true }),
  pattern = "Yazi*",
  once = true,
  callback = function()
    vim.pack.add({
      { src = "https://github.com/mikavilpas/yazi.nvim" },
      { src = "https://github.com/nvim-lua/plenary.nvim" },
    })
    require("yazi").setup({})
  end,
})
map({ "n", "v" }, "<C-n>", "<Cmd>Yazi<CR>", { desc = "Yazi (current file)" })

-- Toggleterm — on command
au("CmdUndefined", {
  group = aug("LazyLoad_Toggleterm", { clear = true }),
  pattern = { "ToggleTerm", "TermExec" },
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/akinsho/toggleterm.nvim" })
    require("toggleterm").setup({ direction = "float", float_opts = { border = "rounded" } })
  end,
})

-- fcitx (IME) — eager (input method, must be always active)
vim.pack.add({ "https://github.com/h-hg/fcitx.nvim" })
