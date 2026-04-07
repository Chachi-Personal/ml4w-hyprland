-- Mason + blink.cmp loaded on first file open (replaces mason-lspconfig bridge)
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("LazyLoad_LSP", { clear = true }),
    once = true,
    callback = function()
        vim.pack.add({
            "https://github.com/mason-org/mason.nvim",
            "https://github.com/saghen/blink.cmp",
            "https://github.com/ray-x/lsp_signature.nvim",
            "https://github.com/folke/lazydev.nvim", -- lua_ls devtools
        })

        require("mason").setup({})
        require("lazydev").setup({})
        require("lsp_signature").setup({ hint_enable = false, handler_opts = { border = "rounded" } })

        require("blink.cmp").setup({
            keymap = { preset = "default" },
            appearance = { use_nvim_cmp_as_default = false },
            sources = { default = { "lsp", "path", "snippets", "buffer" } },
        })

        local ensure_installed = {
            "lua-language-server", -- installs: lua-language-server binary
            "vtsls",      -- installs: vtsls binary
            "rust-analyzer",
            "pylsp",
            "clangd",
            "stylua",
            "prettier",
        }

        local registry = require("mason-registry")
        registry.refresh(function()
            for _, name in ipairs(ensure_installed) do
                local ok, pkg = pcall(registry.get_package, name)
                if ok and not pkg:is_installed() then
                    vim.notify("Mason: installing " .. name, vim.log.levels.INFO)
                    pkg:install()
                end
            end
        end)

        -- Enable LSP servers (configs live in lsp/ directory)
        vim.lsp.enable({
            "lua_ls",
            "vtsls",
            -- "rust_analyzer",
            -- "pylsp",
            -- "clangd",
            -- "tinymist",
        })
    end,
})

-- Copilot — deferred (was loaded after blink.cmp)
vim.schedule(function()
    vim.pack.add({ "https://github.com/zbirenbaum/copilot.lua" })
    require("copilot").setup({
        suggestion = { enabled = false }, -- blink handles UI
        panel = { enabled = false },
    })
end)

-- none-ls (null-ls) — on file open
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("LazyLoad_NoneLS", { clear = true }),
    once = true,
    callback = function()
        vim.pack.add({
            "https://github.com/nvimtools/none-ls.nvim",
            "https://github.com/nvimtools/none-ls-extras.nvim",
            "https://github.com/nvim-lua/plenary.nvim",
        })
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.prettier,
                require("none-ls.diagnostics.eslint"),
                require("none-ls.code_actions.eslint"),
                require("none-ls.diagnostics.ruff"),
            },
        })
    end,
})
