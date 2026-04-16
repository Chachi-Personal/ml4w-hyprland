local langs = {
	"bash",
	"cpp",
	"eslint",
	"html_css",
	"hyprlang",
	"lua",
	"markdown",
	"nix",
	"python",
	"rust",
	"typescript",
	"typst",
}

for _, lang in ipairs(langs) do
	require("lsp.langs." .. lang)
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
	callback = function(args)
		local map = vim.keymap.set
		local s = function(desc)
			return { silent = true, buffer = args.buf, desc = desc }
		end

		-- Navigation
		map("n", "gd", vim.lsp.buf.definition, s("Go to definition"))
		map("n", "gy", vim.lsp.buf.type_definition, s("Go to type definition"))
		map("n", "gK", vim.lsp.buf.signature_help, s("Signature help"))

		-- <leader>l group
		map("n", "<leader>la", vim.lsp.buf.code_action, s("LSP code action"))
		map("n", "<leader>lA", function()
			vim.lsp.buf.code_action({ context = { only = { "source" } } })
		end, s("LSP source action"))
		map("n", "<leader>lr", vim.lsp.buf.rename, s("Rename symbol"))
		map("n", "<leader>lf", function()
			vim.lsp.buf.format({ async = true })
		end, s("Format buffer"))
		map("n", "<leader>lh", vim.lsp.buf.signature_help, s("Signature help"))
		map("n", "<leader>li", "<Cmd>checkhealth vim.lsp<CR>", s("LSP information (checkhealth)"))
		map("n", "<leader>ld", vim.diagnostic.open_float, s("Hover diagnostics"))

		-- CodeLens
		map("n", "<leader>ll", vim.lsp.codelens.refresh, s("CodeLens refresh"))
		map("n", "<leader>lL", vim.lsp.codelens.run, s("CodeLens run"))

		-- Inlay hints
		map("n", "<leader>uh", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }), { bufnr = args.buf })
		end, s("Toggle inlay hints (buffer)"))
		map("n", "<leader>uH", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end, s("Toggle inlay hints (global)"))

		-- Visual mode
		map("x", "<leader>la", vim.lsp.buf.code_action, s("LSP code action"))
		map("x", "<leader>lf", function()
			vim.lsp.buf.format({ async = true })
		end, s("Format selection"))

		map("n", "<leader>lG", vim.lsp.buf.workspace_symbol, s("Search workspace symbols"))

		-- Autoformat toggle (simple flag approach)
		map("n", "<leader>uf", function()
			vim.b.autoformat = not vim.b.autoformat
			vim.notify("Autoformat " .. (vim.b.autoformat and "enabled" or "disabled") .. " (buffer)")
		end, s("Toggle autoformat"))
	end,
})
