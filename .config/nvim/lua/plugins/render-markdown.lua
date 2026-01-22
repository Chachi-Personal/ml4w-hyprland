return {
  "MeanderingProgrammer/render-markdown.nvim",
  cmd = "RenderMarkdown",
  ft = function()
    local plugin = require("lazy.core.config").spec.plugins["render-markdown.nvim"]
    local opts = require("lazy.core.plugin").values(plugin, "opts", false)
    vim.api.nvim_set_hl(0, "ObsidianTodo", { bold = true, fg = "#f78c6c" })
    vim.api.nvim_set_hl(0, "ObsidianDone", { bold = true, fg = "#89ddff" })
    vim.api.nvim_set_hl(0, "ObsidianRightArrow", { bold = true, fg = "#f78c6c" })
    vim.api.nvim_set_hl(0, "ObsidianTilde", { bold = true, fg = "#ff5370" })
    vim.api.nvim_set_hl(0, "ObsidianImportant", { bold = true, fg = "#d73128" })
    vim.api.nvim_set_hl(0, "ObsidianBullet", { bold = true, fg = "#89ddff" })
    vim.api.nvim_set_hl(0, "ObsidianRefText", { underline = true, fg = "#c792ea" })
    vim.api.nvim_set_hl(0, "ObsidianExtLinkIcon", { fg = "#c792ea" })
    vim.api.nvim_set_hl(0, "ObsidianTag", { italic = true, fg = "#89ddff" })
    vim.api.nvim_set_hl(0, "ObsidianBlockID", { italic = true, fg = "#89ddff" })
    vim.api.nvim_set_hl(0, "ObsidianHighlightText", { fg = "#75662e" })
    vim.api.nvim_set_hl(0, "ObsidianDefinition", { fg = "#3CB371" }) -- "#4CAF50"
    vim.api.nvim_set_hl(0, "ObsidianTheorem", { fg = "#D32F2F" }) -- "#b71c1c"
    vim.api.nvim_set_hl(0, "ObsidianProof", { fg = "#848484" })
    vim.api.nvim_set_hl(0, "ObsidianProposition", { fg = "#1976D2" }) -- "#1E90FF"
    vim.api.nvim_set_hl(0, "ObsidianLemma", { fg = "#64b5f6" }) -- "#00B8D4"
    vim.api.nvim_set_hl(0, "ObsidianCorollary", { fg = "#8E24AA" }) -- "#8E44AD"
    vim.api.nvim_set_hl(0, "ObsidianRemark", { fg = "#FF9800" }) -- "#FFA500"
    vim.api.nvim_set_hl(0, "ObsidianAlgorithm", { fg = "#FFEB3B" }) -- "#FFD600"

    return opts.file_types or { "markdown" }
  end,
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        if opts.ensure_installed ~= "all" then
          opts.ensure_installed =
            require("astrocore").list_insert_unique(opts.ensure_installed, { "html", "markdown", "markdown_inline" })
        end
      end,
    },
  },
  opts = {
    completions = { blink = { enabled = false } },
    heading = {
      render_modes = true,
      border = true,
    },
    code = {
      render_modes = true,
      sign = false,
      border = "thin",
    },
    dash = {
      render_modes = true,
    },
    bullet = {
      -- Useful context to have when evaluating values.
      -- | level | how deeply nested the list is, 1-indexed          |
      -- | index | how far down the item is at that level, 1-indexed |
      -- | value | text value of the marker node                     |

      -- Turn on / off list bullet rendering
      enabled = true,
      -- Additional modes to render list bullets
      render_modes = true,
      -- Replaces '-'|'+'|'*' of 'list_item'.
      -- If the item is a 'checkbox' a conceal is used to hide the bullet instead.
      -- Output is evaluated depending on the type.
      -- | function   | `value(context)`                                    |
      -- | string     | `value`                                             |
      -- | string[]   | `cycle(value, context.level)`                       |
      -- | string[][] | `clamp(cycle(value, context.level), context.index)` |
      icons = { "●", "○", "◆", "◇" },
      -- Replaces 'n.'|'n)' of 'list_item'.
      -- Output is evaluated using the same logic as 'icons'.
      ordered_icons = function(ctx)
        local value = vim.trim(ctx.value)
        local index = tonumber(value:sub(1, #value - 1))
        return ("%d."):format(index > 1 and index or ctx.index)
      end,
      -- Padding to add to the left of bullet point.
      -- Output is evaluated depending on the type.
      -- | function | `value(context)` |
      -- | integer  | `value`          |
      left_pad = 0,
      -- Padding to add to the right of bullet point.
      -- Output is evaluated using the same logic as 'left_pad'.
      right_pad = 0,
      -- Highlight for the bullet icon.
      -- Output is evaluated using the same logic as 'icons'.
      highlight = "ObsidianBullet",
      -- Highlight for item associated with the bullet point.
      -- Output is evaluated using the same logic as 'icons'.
      scope_highlight = {},
    },
    checkbox = {
      enabled = true,
      -- Additional modes to render checkboxes.
      render_modes = true,
      -- Render the bullet point before the checkbox.
      bullet = false,
      -- Padding to add to the right of checkboxes.
      right_pad = 1,
      unchecked = {
        icon = "󰄱", -- "󰄱 "
        -- Highlight for the unchecked icon.
        highlight = "ObsidianTodo",
        -- Highlight for item associated with unchecked checkbox.
        scope_highlight = nil,
      },
      checked = {
        -- Replaces '[x]' of 'task_list_marker_checked'.
        icon = "", -- "󰱒 ",
        -- Highlight for the checked icon.
        highlight = "ObsidianDone",
        -- Highlight for item associated with checked checkbox.
        scope_highlight = nil,
      },
        -- Define custom checkbox states, more involved, not part of the markdown grammar.
        -- The key is for healthcheck and to allow users to change its values, value type below.
        -- As a result this requires neovim >= 0.10.0 since it relies on 'inline' extmarks.
        -- | raw             | matched against the raw text of a 'shortcut_link'           |
        -- | rendered        | replaces the 'raw' value when rendering                     |
        -- | highlight       | highlight for the 'rendered' icon                           |
        -- | scope_highlight | optional highlight for item associated with custom checkbox |
        -- stylua: ignore
        custom = {
            todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
            scheduled = { raw = "[>]", rendered = "", highlight = "ObsidianRightArrow", scope_highlight = nil},
            cancelled = {raw="[~]", rendered = "x", highlight = "ObsidianTilde", scope_highlight = '@markup.strikethrough' },
            important =  {raw="[!]", rendered = "", highlight = "ObsidianImportant", scope_highlight = nil },
        },
    },
    quote = {
      render_modes = true,
    },
    pipe_table = {
      render_modes = true,
      preset = "round", -- heavy, double, round, none
    },
    callout = {
      definition = {
        raw = "[!DEF]",
        rendered = " Definition",
        highlight = "ObsidianDefinition",
        category = "custom",
      },
      theorem = { raw = "[!THEOREM]", rendered = " Theorem", highlight = "ObsidianTheorem", category = "custom" },
      proof = { raw = "[!PROOF]", rendered = " Proof", highlight = "ObsidianProof", category = "custom" },
      proposition = {
        raw = "[!PROP]",
        rendered = " Proposition",
        highlight = "ObsidianProposition",
        category = "custom",
      },
      lemma = { raw = "[!LEMMA]", rendered = " Lemma", highlight = "ObsidianLemma", category = "custom" },
      corollary = {
        raw = "[!COR]",
        rendered = " Corollary",
        highlight = "ObsidianCorollary",
        category = "custom",
      },
      remark = { raw = "[!REMARK]", rendered = " Remark", highlight = "ObsidianRemark", category = "custom" },
      algorithm = {
        raw = "[!ALGO]",
        rendered = " Algorithm",
        highlight = "ObsidianAlgorithm",
        category = "custom",
      },
    },
    link = {
      render_modes = true,
    },
  },
}
