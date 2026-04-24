-- Register build hook for blink.cmp before vim.pack.add()
-- vim.api.nvim_create_autocmd("PackChanged", {
-- 	callback = function(ev)
-- 		local name = ev.data.spec.name
-- 		local kind = ev.data.kind
-- 		if name == "blink.cmp" and (kind == "install" or kind == "update") then
-- 			vim.notify("blink.cmp: building Rust binary...", vim.log.levels.INFO)
-- 			vim.system({ "cargo", "build", "--release" }, { cwd = ev.data.path }):wait()
-- 			vim.notify("blink.cmp: build complete", vim.log.levels.INFO)
-- 		end
-- 	end,
-- })
-- Core LSP infrastructure - loaded on first file open
-- Mason + blink.cmp loaded on first file open (replaces mason-lspconfig bridge)
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("LSP_Core", { clear = true }),
	once = true,
	callback = function()
		vim.pack.add({
			{ src = "https://github.com/mason-org/mason.nvim" },
			{ src = "https://github.com/saghen/blink.lib" },
			{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
			{ src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("^2") },
			{ src = "https://github.com/iurimateus/luasnip-latex-snippets.nvim" },
			{ src = "https://github.com/ray-x/lsp_signature.nvim" },
			{ src = "https://github.com/folke/lazydev.nvim" }, -- lua_ls devtools
		})

		require("mason").setup({})
		require("lazydev").setup({
			library = {
				{ path = "snacks.nvim", words = { "Snacks" } },
			},
		})
		require("lsp_signature").setup({
			hint_enable = false,
			handler_opts = { border = "rounded" },
		})
		require("blink.cmp").setup({
			keymap = {
				preset = "none",
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },

				-- Tab: cycle forward through list (text auto-inserts as you go)
				-- Also jumps to next snippet placeholder AFTER acceptance
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

				-- Enter: accept selected item (expands snippet if it is one)
				["<CR>"] = { "accept", "fallback" },

				-- Arrow keys as alternative navigation
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },

				-- Documentation scrolling
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },

				-- Signature help
				["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
			},
			completion = {
				list = {
					selection = {
						preselect = false, -- first item pre-selected when menu opens
						auto_insert = true, -- text changes as you Tab through the list
					},
					cycle = {
						from_bottom = true, -- Tab at bottom wraps to top
						from_top = true, -- S-Tab at top wraps to bottom
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				menu = {
					border = nil,
				},
				-- Don't re-trigger completions while inside a snippet
				trigger = {
					show_in_snippet = false,
				},
			},
			appearance = { use_nvim_cmp_as_default = false },
			snippets = { preset = "luasnip" },
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
		})
		require("luasnip-latex-snippets").setup({
			use_treesitter = true,
			allow_on_markdown = true,
		})
		require("luasnip").config.setup({
			enable_autosnippets = true,
		})
		require("luasnip.loaders.from_vscode").lazy_load({
			paths = { vim.fn.stdpath("config") .. "/snippets" },
		})
		require("luasnip.loaders.from_snipmate").lazy_load()
		require("luasnip.loaders.from_lua").lazy_load()
	end,
})

-- none-ls (null-ls) — on file open
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("LSP_NoneLS", { clear = true }),
	once = true,
	callback = function()
		-- tools.lua or lsp/completion.lua
		vim.pack.add({ "https://github.com/stevearc/conform.nvim" })
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
			},
			format_on_save = { timeout_ms = 1000, lsp_fallback = true },
		})
		-- vim.pack.add({
		-- 	"https://github.com/nvimtools/none-ls.nvim",
		-- 	"https://github.com/nvimtools/none-ls-extras.nvim",
		-- 	"https://github.com/nvim-lua/plenary.nvim",
		-- })
		-- local null_ls = require("null-ls")
		-- null_ls.setup({
		-- 	sources = {
		-- 		null_ls.builtins.formatting.stylua,
		-- 		null_ls.builtins.formatting.prettier,
		-- 		-- null_ls.builtins.code_actions.statix,
		-- 		-- null_ls.builtins.diagnostics.deadnix,
		-- 	},
		-- })
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
