---@type vim.lsp.Config
return {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
	settings = {
		lint = {
			preview = true,
		},
		format = {
			preview = true,
			backend = "uv",
		},
	},
}
