local map = vim.keymap.set

-- Snacks — eager (dashboard, notifs, etc.)
vim.pack.add({ "https://github.com/folke/snacks.nvim" })
require("snacks").setup({
  bigfile = { enabled = true },
  dashboard = { enabled = false },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  statuscolumn = { enabled = true },
  picker = { enabled = true },
})

map("n", "<leader>ff", function()
  require("snacks").picker.files()
end, { desc = "Find files" })
