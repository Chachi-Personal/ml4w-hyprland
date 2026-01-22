-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
----------------------------------------------------------------------------------------------

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    features = { -- Configure core features of AstroNvim
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    diagnostics = { -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
      virtual_text = true,
      underline = true,
    },
    filetypes = {
      extension = {},
      filename = {},
      pattern = {},
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap

        wildignorecase = true,
        swapfile = false,
        scrolloff = 10,

        -- conceallevel = 2,
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
        python3_host_prog = vim.fn.expand "$CONDA_PREFIX/bin/python",
      },
    },
    -- Mappings can be configured through AstroCore as well.
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- make cursor stay when concattinating with J
        J = { "mzJ`z" },

        -- Line Swapping
        ["<A-j>"] = { "<cmd>m .+1<CR>==" },
        ["<A-k>"] = { "<cmd>m .-2<CR>==" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        ["<C-_>"] = { "<Cmd>normal gcc<CR>", desc = "Toggle Comment" },
        ["<C-/>"] = { "<Cmd>normal gcc<CR>", desc = "Toggle Comment" },

        -- Compiler.nvim
        ["<Leader>rf"] = {
          "<cmd>CompilerOpen<CR>",
          desc = "Run file (Compiler.nvim)",
        },
        ["<Leader>rr"] = {
          "<cmd>CompilerRedo<CR>",
          desc = "Rerun compiler",
        },
        ["<Leader>rR"] = {
          "<cmd>CompilerStop<CR>" -- (Optional, to dispose all tasks before redo)
            .. "<cmd>CompilerRedo<CR>",
          desc = "Fresh rerun compiler",
        },
        ["<Leader>rt"] = {
          "<cmd>CompilerToggleResults<CR>",
          desc = "Show compiler results",
        },
        ["<Leader>rs"] = {
          "<cmd>SnipRun<CR>",
          desc = "Run SnipRun",
        },
        ["<Leader>ti"] = {
          function()
            local img = require "image"
            if img.is_enabled() then
              img.disable()
              vim.notify("Images disabled", vim.log.levels.INFO, { title = "image.nvim" })
            else
              img.enable()
              vim.notify("Images enabled", vim.log.levels.INFO, { title = "image.nvim" })
            end
          end,
          desc = "Toggle image.nvim",
        },
      },
      i = {
        -- NOTE better undo breaks
        ["<Space>"] = { "<Space><C-g>u" },
        [","] = { ",<C-g>u" },
        ["."] = { ".<C-g>u" },
        ["!"] = { "!<C-g>u" },
        ["?"] = { "?<C-g>u" },

        -- Line Swapping
        ["<A-j>"] = { "<Esc><cmd>m .+1<CR>==gi" },
        ["<A-k>"] = { "<Esc><cmd>m .-2<CR>==gi" },

        -- Better escape
        ["<C-c>"] = { "<Esc>" },

        ["<C-s>"] = { "<Esc><cmd>silent! update! | redraw<CR>" },
      },
      v = {
        -- Line Swapping
        ["<A-k>"] = { ":m '<-2<CR><CR>gv=gv" },
        ["<A-j>"] = { ":m '>+1<CR><CR>gv=gv" },

        ["<C-_>"] = { "<Cmd>normal gcc<CR>", desc = "Toggle Comment" },
        ["<C-/>"] = { "<Cmd>normal gcc<CR>", desc = "Toggle Comment" },

        ["<C-c>"] = { "<Esc>" },
      },
    },
    autocmds = {
      typst_settings = {
        {
          event = "BufEnter",
          pattern = "*.typ",
          desc = "set keymaps for typst files",
          callback = function()
            vim.keymap.set("n", "<f3>", "<cmd>TypstPreviewToggle<cr>", { noremap = true, silent = true })
            vim.b.watch_typst = false
            local toggle_watch_typst = function()
              vim.b.watch_typst = not vim.b.watch_typst
              if vim.b.watch_typst then
                vim.notify("Typst watch started", vim.log.levels.INFO, { title = "Typst" })
              else
                vim.notify("Typst watch stopped", vim.log.levels.INFO, { title = "Typst" })
              end
            end

            vim.keymap.set("n", "<f2>", toggle_watch_typst, { noremap = true, silent = true, buffer = true })
          end,
        },
        {
          event = "BufWritePost",
          pattern = "*.typ",
          desc = "Watch typst",
          callback = function()
            if not vim.b.watch_typst then return end
            local file = vim.fn.expand "%:p"
            local dir = vim.fn.expand "%:p:h"
            local cmd = string.format('typst compile "%s"', file, dir)
            vim.fn.jobstart(cmd, {
              on_exit = function(_, exit_code)
                if exit_code == 0 then
                  vim.notify("Typst compilation successful", vim.log.levels.INFO, { title = "Typst" })
                else
                  vim.notify("Typst compilation failed", vim.log.levels.ERROR, { title = "Typst" })
                end
              end,
            })
          end,
        },
      },
      c_settings = {
        {
          event = "BufEnter",
          pattern = "*.c",
          desc = "c settings",
          callback = function()
            local Terminal = require("toggleterm.terminal").Terminal

            -- Function to compile and run the current C file
            local function run_c_file()
              local file_path = vim.fn.expand "%:p" -- Get the full path of the current file
              local file_name = vim.fn.expand "%:t:r" -- Get the file name without extension
              local compile_cmd = string.format("gcc %s -o %s; ./%s", file_path, file_name, file_name)

              local c_terminal = Terminal:new {
                cmd = compile_cmd, -- Command to compile and run the C file
                direction = "float", -- Open in a floating terminal
                close_on_exit = false, -- Keep the terminal open after execution
              }
              c_terminal:toggle()
            end

            -- Map <F5> to compile and run the C file
            vim.keymap.set("n", "<f2>", run_c_file, { noremap = true, silent = true })
          end,
        },
      },
      rmd_settings = {
        {
          event = "BufEnter",
          pattern = "*.rmd",
          desc = "rmd settings",
          callback = function()
            local compile_rmd = function()
              local command = "R -e \"rmarkdown::render('" .. vim.fn.expand "%" .. "')\""
              local handle = io.popen(command)
              local output = handle:read "*a"
              handle:close()
              vim.notify(output, vim.log.levels.INFO, { title = "Rmd Compilation" })
            end
            vim.keymap.set("n", "<f3>", compile_rmd, { noremap = true, silent = false, buffer = true })
          end,
        },
      },
      markdown_settings = {
        {
          event = "BufEnter",
          pattern = "*.md",
          desc = "markdown settings",
          callback = function()
            vim.opt.tabstop = 2
            vim.opt.softtabstop = 2
            vim.opt.shiftwidth = 2

            local toggle_peek = function()
              if not vim.g.peek_open then
                require("peek").open()
                vim.notify("Peek opened", vim.log.levels.INFO, { title = "Markdown Preview" })
              else
                require("peek").close()
                vim.notify("Peek closed", vim.log.levels.INFO, { title = "Markdown Preview" })
              end
              vim.g.peek_open = not vim.g.peek_open
            end

            vim.keymap.set("n", "<f3>", toggle_peek, { noremap = true, silent = true, buffer = true })
          end,
        },
      },
      blade_settings = {
        {
          event = "BufEnter",
          pattern = "*.blade.php",
          callback = function()
            vim.bo.commentstring = "{{-- %s --}}" -- Set comment string for Blade files
            vim.bo.comments = ":{{-- --}}"
          end,
        },
      },
    },
  },
}
