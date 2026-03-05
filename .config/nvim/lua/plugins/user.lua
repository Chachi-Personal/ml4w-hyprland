---@type LazySpec
return {
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },
  { -- Snacks: customize dashboard
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      ---@type snacks.scroll.Config
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 10, total = 200 },
          easing = "linear",
        },
        animate_repeat = {
          delay = 100,
          duration = { step = 5, total = 50 },
          easing = "linear",
        },
        filter = function(buf)
          return vim.g.snacks_scroll ~= false
            and vim.b[buf].snacks_scroll ~= false
            and vim.bo[buf].buftype ~= "terminal"
        end,
      },
      ---@type snacks.image.Config
      image = {
        enabled = true,
        math = {
          enabled = true,
          typst = {
            tpl = [[
        #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
        #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
        #set text(size: 12pt, fill: rgb("${color}"))
        ${header}
        ${content}]],
          },
        },
      },
    },
    keys = {
      { "<leader><space>", function() require("snacks").picker.smart() end, desc = "Smart Find Files" },
      { "<C-p>", function() require("snacks").picker.files() end, desc = "Smart Find Files" },
      { "<Leader>.", function() require("snacks").scratch() end, desc = "Toggle Scratch Buffer" },
      { "<Leader>f.", function() require("snacks").scratch.select() end, desc = "Toggle Scratch Buffer" },
      { "<Leader>gg", function() require("snacks").lazygit.open() end, desc = "ToggleTerm LazyGit" },
      {
        "<leader>ts",
        function()
          local scroll = require("snacks").scroll
          if scroll.enabled then
            scroll.disable()
            vim.notify("Smooth scroll disabled", vim.log.levels.INFO, { title = "Snacks" })
          else
            scroll.enable()
            vim.notify("Smooth scroll enabled", vim.log.levels.INFO, { title = "Snacks" })
          end
        end,
        desc = "Toggle Smooth Scroll",
      },
    },
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = true },

  { -- LuaSnip
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
      require("luasnip.loaders.from_vscode").lazy_load {
        paths = { vim.fn.stdpath "config" .. "/snippets" },
      }
    end,
  },

  { -- mason-tool-installer
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      auto_update = true,
    },
  },

  { -- None-ls
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      -- opts variable is the default configuration table for the setup function call
      local null_ls = require "null-ls"

      -- Check supported formatters and linters
      -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics

      -- Only insert new sources, do not replace the existing ones
      -- (If you wish to replace, use `opts.sources = {}` instead of the `list_insert_unique` function)
      opts.sources = require("astrocore").list_insert_unique(opts.sources, {
        -- Set a formatter
        -- null_ls.builtins.formatting.stylua,
        -- null_ls.builtins.formatting.prettier,
        -- null_ls.builtins.formatting.typstyle,

        -- Set diagnostics
      })
    end,
  },

  {
    "toppair/peek.nvim",
    lazy = true,
    build = "deno task --quiet build:fast",
    dependencies = {
      "AstroNvim/astrocore",
      opts = {
        commands = {
          PeekOpen = { function() require("peek").open() end, desc = "Open preview window" },
          PeekClose = { function() require("peek").close() end, desc = "Close preview window" },
        },
      },
    },
    opts = {
      app = { "brave", "--new-window" },
    },
  },
  {
    "ribelo/taskwarrior.nvim",
    cmd = "Task",
    opts = {
      filter = { "noice", "nofile" }, -- Filtered buffer_name and buffer_type.
      task_file_name = ".taskwarrior.json",
      -- After what period of time should a task be halted due to inactivity?
      granulation = 60 * 1000 * 10,
      notify_start = true, -- Should a notification pop up after starting the task?
      notify_stop = true,
      notify_error = true,
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "zk", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "<C-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
}
