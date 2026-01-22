local M = {}

local environments = {
  definition = { directory = "/home/chachi/obsidian-vault/uni/environments/definitions/", name = "definition" },
  theorem = { directory = "/home/chachi/obsidian-vault/uni/environments/theorems/", name = "theorem" },
  proposition = { directory = "/home/chachi/obsidian-vault/uni/environments/propositions/", name = "proposition" },
  lemma = { directory = "/home/chachi/obsidian-vault/uni/environments/lemmas/", name = "lemma" },
}

function M.add_link()
  local env_names = {}
  for env_name, _ in pairs(environments) do
    table.insert(env_names, env_name)
  end

  vim.ui.select(env_names, { prompt = "Choose link type" }, function(selected_env)
    if not selected_env then return end
    vim.ui.input({
      prompt = "Enter name for " .. selected_env,
    }, function(name)
      if not name or name == "" then return end
      local target_path = environments[selected_env].directory .. name .. ".md"
      local bufnr = vim.api.nvim_get_current_buf()
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      if vim.fn.filereadable(target_path) == 0 then vim.fn.writefile({}, target_path) end
      vim.cmd("edit " .. vim.fn.fnameescape(target_path))
      vim.api.nvim_create_autocmd("BufWinLeave", {
        buffer = vim.api.nvim_get_current_buf(),
        once = true,
        callback = function()
          vim.cmd("buffer " .. bufnr)
          vim.api.nvim_win_set_cursor(0, { row, col })
          local link_txt = ("[[%s]]"):format(name)
          vim.api.nvim_put({ link_txt }, "c", true, true)
        end,
      })
    end)
  end)
end

-- function M.setup() vim.keymap.set("i", "<C-l", M.add_link) end

return M
