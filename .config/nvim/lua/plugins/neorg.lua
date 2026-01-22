return {
  "nvim-neorg/neorg",
  version = "^9",
  event = "VeryLazy",
  ft = "norg",
  enabled = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "benlubas/neorg-interim-ls",
    "3rd/image.nvim",
    "juniorsundar/neorg-extras",
    "folke/snacks.nvim",
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<Leader>o"] = { "<Cmd>Neorg index<CR>", desc = "Open Neorg" },
            ["<Leader>oR"] = { "<Cmd>Neorg return<CR>", desc = "Exit Neorg" },
            ["<Leader>oj"] = { "<Cmd>Neorg journal<CR>", desc = "Journal" },
            ["<Leader>os"] = { "<Cmd>Neorg generate-workspace-summary<CR>", desc = "Generate Summary" },
            ["<Leader>oa"] = { "<Cmd>Neorg agenda<CR>", desc = "Agenda" },
            ["<Leader>oad"] = { "<Cmd>Neorg agenda day<CR>", desc = "Day" },
            ["<Leader>oap"] = { "<Cmd>Neorg agenda page<CR>", desc = "Page" },
            ["<Leader>oat"] = { "<Cmd>Neorg agenda tag<CR>", desc = "Tag" },
            ["<Leader>on"] = { "<Plug>(neorg.dirman.new-note)", desc = "Note" },
            -- ["<Leader>oc"] = { desc = "Code" },
            ["<Leader>ocm"] = { "<Plug>(neorg.looking-glass.magnify-code-block)", desc = "Magnify" },
            ["<Leader>oi"] = { desc = "Insert" },
            ["<Leader>oid"] = { "<Plug>(neorg.tempus.insert-date)", desc = "Date" },
            ["<Leader>oim"] = { "<Cmd>Neorg inject-metadata<CR>", desc = "Metadata" },
            ["<Leader>ol"] = { desc = "List" },
            ["<Leader>oli"] = { "<Plug>(neorg.pivot.list.invert)", desc = "Invert" },
            ["<Leader>olt"] = { "<Plug>(neorg.pivot.list.toggle)", desc = "Toggle Ordered/Unordered" },
            ["<Leader>ot"] = { desc = "Tasks" },
            ["<Leader>ota"] = { "<Plug>(neorg.qol.todo-items.todo.task-ambiguous)", desc = "Mark as ambiguous" },
            ["<Leader>otc"] = { "<Plug>(neorg.qol.todo-items.todo.task-cancelled)", desc = "Mark as cancelled" },
            ["<Leader>otd"] = { "<Plug>(neorg.qol.todo-items.todo.task-done)", desc = "Mark as done" },
            ["<Leader>oth"] = { "<Plug>(neorg.qol.todo-items.todo.task-on-hold)", desc = "Mark as on hold" },
            ["<Leader>oti"] = { "<Plug>(neorg.qol.todo-items.todo.task-important)", desc = "Mark as important" },
            ["<Leader>otp"] = { "<Plug>(neorg.qol.todo-items.todo.task-pending)", desc = "Mark  as pending" },
            ["<Leader>otr"] = { "<Plug>(neorg.qol.todo-items.todo.task-recurring)", desc = "Mark  as recurring" },
            ["<Leader>otu"] = { "<Plug>(neorg.qol.todo-items.todo.task-undone)", desc = "Mark  as undone" },
            ["<Leader>or"] = { desc = "Roam" },
            ["<Leader>orb"] = { "<Cmd>Neorg roam backlinks<CR>", desc = "Backlinks" },

            -- ["<Leader>ojy"] = { "<Cmd>Neorg journal yesterday<CR>", desc = "Neorg Journal Yesterday" },
          },
        },
      },
    },
  },
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.concealer"] = {
          config = {
            icon_preset = "basic", -- basic | diamond | varied
          },
        }, -- Adds pretty icons to your documents
        -- ["core.keybinds"] = {}, -- Adds default keybindings
        ["core.completion"] = {
          config = {
            engine = { module_name = "external.lsp-completion" },
          },
        }, -- Enables support for completion plugins
        ["core.journal"] = {}, -- Enables support for the journal module
        ["core.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/neorg/notes",
            },
            default_workspace = "notes",
          },
        },
        ["core.summary"] = {},
        ["core.integrations.image"] = {},
        ["core.latex.renderer"] = {},
        ["core.export"] = {},
        ["core.export.markdown"] = {},
        ["external.interim-ls"] = {
          config = {
            completion_provider = {
              enable = true,
              documentation = false,
              categories = false,
              people = {
                enable = false,
                path = "people",
              },
            },
          },
        },
        ["external.many-mans"] = {
          config = {
            metadata_fold = true, -- If want @data property ... @end to fold
            code_fold = true, -- If want @code ... @end to fold
          },
        },
        ["external.agenda"] = {
          config = {
            workspace = nil,
          },
        },
        ["external.roam"] = {
          config = {
            fuzzy_finder = "Snacks",
            fuzzy_backlinks = true,
            roam_base_directory = "",
            node_no_name = false, -- no suffix name in node filename
            node_name_randomiser = false, -- Tokenise node name suffix for more randomisation
            node_name_snake_case = false, -- snake_case the names if node_name_randomiser = false
          },
        },
      },
    })
  end,
  specs = {
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        if opts.ensure_installed ~= "all" then
          opts.ensure_installed =
            require("astrocore").list_insert_unique(opts.ensure_installed, { "norg", "norg_meta" })
        end
      end,
    },
  },
}
