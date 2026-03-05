return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- use latest release, remove to use latest commit
  ft = "markdown",
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- this will be removed in the next major release
    workspaces = {
      {
        name = "main",
        path = "~/Vault/",
      },
    },
    open = {
      use_advanced_uri = true,
    },
    finder = "snacks.pick",

    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
    },
    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
    },
    completion = {
      nvim_cmp = false,
      blink = true,
      min_chars = 0,
    },

    ui = {
      enable = false, -- set to false to disable all additional syntax features
    },
    checkbox = {
      order = { " ", "!", "~", ">", "x" },
    },

    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten style (YYYYMMDDHHMMSS)
      if title then return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower() end
      return tostring(os.time()) .. string.char(math.random(65, 90)):rep(4)
    end,
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "Thiago4532/mdmath.nvim", enabled = false },
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["gf"] = {
              function()
                if require("obsidian").util.cursor_on_markdown_link() then
                  return "<Cmd>Obsidian follow_link<CR>"
                else
                  return "gf"
                end
              end,
              desc = "Obsidian Follow Link",
            },
            ["<Leader>o"] = { "<Cmd>Obsidian<CR>", desc = "Obsidian" },
            ["<Leader>oh"] = { "<Cmd>Obsidian quick_switch home<CR>", desc = "Home" },
            ["<Leader>or"] = { "<Cmd>Obsidian rename<CR>", desc = "Rename" },

            -- ["<Leader>of"] = { desc = "Search" },
            ["<Leader>ob"] = { "<Cmd>Obsidian backlinks<CR>", desc = "Backlinks" },
            ["<Leader>ol"] = { "<Cmd>Obsidian links<CR>", desc = "Links" },

            ["<Leader>oq"] = { "<Cmd>Obsidian quick_switch<CR>", desc = "Quick Switch" },
            -- ["<Leader>otc"] = { "<Cmd>Obsidian toggle_checkbox<CR>", desc = "Toggle checkbox" },
          },
          v = {
            ["<Leader>ol"] = { "<Cmd>Obsidian link", desc = "Link selection to note" },
          },
          i = {
            ["<C-B>"] = { "****<Left><Left>", desc = "Bold", noremap = true, silent = true },
            -- ["<C-I>"] = { "____<Left><Left>", desc = "Italic", noremap = true, silent = true },
            ["<C-l>"] = { require("notes").ad_link, desc = "Add link", noremap = true, silent = true },
          },
        },
      },
    },
  },
}
-- return { -- Obsidian
--   "obsidian-nvim/obsidian.nvim",
--   -- the obsidian vault in this default config  ~/obsidian-vault
--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
--   -- event = { "bufreadpre " .. vim.fn.expand "~" .. "/my-vault/**.md" },
--   event = { "BufReadPre  */obsidian-vault/*.md" },
--
--   cmd = { "Obsidian", "ObsidianFollowLink", "ObsidianQuickSwitch" },
--   enabled = true,
--
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     -- { "Thiago4532/mdmath.nvim" },
--     {
--       "AstroNvim/astrocore",
--       opts = {
--         mappings = {
--           n = {
--             ["gf"] = {
--               function()
--                 if require("obsidian").util.cursor_on_markdown_link() then
--                   return "<Cmd>Obsidian follow_link<CR>"
--                 else
--                   return "gf"
--                 end
--               end,
--               desc = "Obsidian Follow Link",
--             },
--             ["<Leader>o"] = { "<Cmd>Obsidian<CR>", desc = "Obsidian" },
--             ["<Leader>oh"] = { "<Cmd>Obsidian quick_switch home<CR>", desc = "Home" },
--             ["<Leader>or"] = { "<Cmd>Obsidian rename<CR>", desc = "Rename" },
--
--             -- ["<Leader>of"] = { desc = "Search" },
--             ["<Leader>ob"] = { "<Cmd>Obsidian backlinks<CR>", desc = "Backlinks" },
--             ["<Leader>ol"] = { "<Cmd>Obsidian links<CR>", desc = "Links" },
--
--             ["<Leader>oq"] = { "<Cmd>Obsidian quick_switch<CR>", desc = "Quick Switch" },
--             -- ["<Leader>otc"] = { "<Cmd>Obsidian toggle_checkbox<CR>", desc = "Toggle checkbox" },
--           },
--           v = {
--             ["<Leader>ol"] = { "<Cmd>Obsidian link", desc = "Link selection to note" },
--           },
--           i = {
--             ["<C-B>"] = { "****<Left><Left>", desc = "Bold", noremap = true, silent = true },
--             -- ["<C-I>"] = { "____<Left><Left>", desc = "Italic", noremap = true, silent = true },
--             ["<C-l>"] = { require("notes").ad_link, desc = "Add link", noremap = true, silent = true },
--           },
--         },
--       },
--     },
--   },
--   opts = function(_, opts)
--     -- vim.keymap.set("i", "<C-l>", require("notes").add_link)
--     local astrocore = require "astrocore"
--
--     -- See https://github.com/obsidian-nvim/obsidian.nvim/wiki/Attachment
--     vim.ui.open = (function(overridden)
--       return function(uri, opt)
--         if vim.endswith(uri, ".png") then
--           vim.cmd("edit " .. uri) -- early return to just open in neovim
--           return
--         elseif vim.endswith(uri, ".pdf") then
--           opt = { cmd = { "zathura" } } -- override open app
--         end
--         return overridden(uri, opt)
--       end
--     end)(vim.ui.open)
--
--     return astrocore.extend_tbl(opts, {
--       workspaces = {
--         {
--           path = vim.env.HOME .. "/obsidian-vault", -- specify the vault location. no need to call 'vim.fn.expand' here
--         },
--       },
--       open = {
--         use_advanced_uri = true,
--       },
--       finder = "snacks.pick",
--
--       templates = {
--         subdir = "templates",
--         date_format = "%Y-%m-%d-%a",
--         time_format = "%H:%M",
--       },
--       daily_notes = {
--         folder = "daily",
--         date_format = "%Y-%m-%d",
--         alias_format = "%B %-d, %Y",
--       },
--       completion = {
--         nvim_cmp = false,
--         blink = true,
--         min_chars = 0,
--       },
--
--       ui = {
--         enable = false, -- set to false to disable all additional syntax features
--         ignore_conceal_warn = false, -- set to true to disable conceallevel specific warning
--         update_debounce = 200, -- update delay after a text change (in milliseconds)
--         max_file_length = 5000, -- disable UI features for files with more than this many lines
--         -- Define how various check-boxes are displayed
--         -- checkboxes = {
--         -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
--         -- [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
--         -- ["x"] = { char = "", hl_group = "ObsidianDone" },
--         -- [">"] = { char = "", hl_group = "ObsidianRightArrow" },
--         -- ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
--         -- ["!"] = { char = "", hl_group = "ObsidianImportant" },
--         -- Replace the above with this if you don't have a patched font:
--         -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
--         -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },
--
--         -- You can also add more custom ones...
--         -- },
--         -- Use bullet marks for non-checkbox lists.
--         bullets = { char = "•", hl_group = "ObsidianBullet" },
--         external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
--         -- Replace the above with this if you don't have a patched font:
--         -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
--         reference_text = { hl_group = "ObsidianRefText" },
--         highlight_text = { hl_group = "ObsidianHighlightText" },
--         tags = { hl_group = "ObsidianTag" },
--         block_ids = { hl_group = "ObsidianBlockID" },
--         hl_groups = {
--           -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
--           ObsidianTodo = { bold = true, fg = "#f78c6c" },
--           ObsidianDone = { bold = true, fg = "#89ddff" },
--           ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
--           ObsidianTilde = { bold = true, fg = "#ff5370" },
--           ObsidianImportant = { bold = true, fg = "#d73128" },
--           ObsidianBullet = { bold = true, fg = "#89ddff" },
--           ObsidianRefText = { underline = true, fg = "#c792ea" },
--           ObsidianExtLinkIcon = { fg = "#c792ea" },
--           ObsidianTag = { italic = true, fg = "#89ddff" },
--           ObsidianBlockID = { italic = true, fg = "#89ddff" },
--           ObsidianHighlightText = { fg = "#75662e" },
--           ObsidianDefinition = { fg = "#3CB371" }, -- "#4CAF50"
--           ObsidianTheorem = { fg = "#D32F2F" }, -- "#b71c1c"
--           ObsidianProof = { fg = "#848484" },
--           ObsidianProposition = { fg = "#1976D2" }, -- "#1E90FF"
--           ObsidianLemma = { fg = "#64b5f6" }, -- "#00B8D4"
--           ObsidianCorollary = { fg = "#8E24AA" }, -- "#8E44AD"
--           ObsidianRemark = { fg = "#FF9800" }, -- "#FFA500"
--           ObsidianAlgorithm = { fg = "#FFEB3B" }, -- "#FFD600"
--         },
--       },
--       legacy_commands = false,
--       checkbox = {
--         order = { " ", "!", "~", ">", "x" },
--       },
--     })
--   end,
-- }
