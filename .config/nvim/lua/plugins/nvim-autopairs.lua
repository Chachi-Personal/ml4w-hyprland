return { -- nvim-autopairs
  "windwp/nvim-autopairs",
  config = function(plugin, opts)
    require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
    -- add more custom autopairs configuration such as custom rules
    local npairs = require "nvim-autopairs"
    local Rule = require "nvim-autopairs.rule"
    local cond = require "nvim-autopairs.conds"
    npairs.add_rules {
      -- specify a list of rules to add
      Rule(" ", " ", { "-norg", "-markdown" }):with_pair(function(options)
        local pair = options.line:sub(options.col - 1, options.col)
        return vim.tbl_contains({ "()", "[]", "{}", "$$" }, pair)
      end):with_del(function(options)
        local pair = options.line:sub(options.col - 1, options.col)
        return vim.tbl_contains({ "()", "[]", "{}", "$$" }, pair)
      end),
      Rule("( ", " )")
        :with_pair(function() return false end)
        :with_move(function(options) return options.prev_char:match ".%)" ~= nil end)
        :use_key ")",
      Rule("{ ", " }")
        :with_pair(function() return false end)
        :with_move(function(options) return options.prev_char:match ".%}" ~= nil end)
        :use_key "}",
      Rule("[ ", " ]")
        :with_pair(function() return false end)
        :with_move(function(options) return options.prev_char:match ".%]" ~= nil end)
        :use_key "]",
      Rule("$ ", " $")
        :with_pair(function() return false end)
        :with_move(function(options) return options.prev_char:match ".%$" ~= nil end)
        :use_key "$",
    }

    npairs.add_rules {
      Rule("(", ")", { "typst", "markdown" }):with_pair(cond.after_text "$"),
      Rule('"', '"', { "typst", "markdown" }):with_pair(cond.after_text "$"),
      Rule("$", "$", { "typst", "markdown" }):with_move():use_key "$",
      Rule("_", "_", { "typst", "markdown" })
        :with_pair(function(options)
          local line = options.line
          local col = options.col
          return col == 1 or line:sub(col - 1, col - 1):match "%s" ~= nil
        end)
        :with_move()
        :use_key "_",
      -- Rule("*", "*", { "typst", "markdown" })
      --   :with_pair(function(options)
      --     local line = options.line
      --     local col = options.col
      --     return col == 1 or line:sub(col - 1, col - 1):match "%s" ~= nil
      --   end)
      --   :with_move()
      --   :use_key "*",
    }
  end,
}
