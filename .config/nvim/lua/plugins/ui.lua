local defer = vim.schedule -- shorthand for deferred loading

-- Colorscheme — must load eagerly
vim.pack.add({
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/xiyaowong/transparent.nvim",
	"https://github.com/nvim-mini/mini.icons",
})

vim.pack.add({
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/akinsho/bufferline.nvim",
	"https://github.com/stevearc/aerial.nvim",
})
vim.cmd.colorscheme("tokyonight-night")

-- Transparent background
require("transparent").setup({ extra_groups = { "NormalFloat" } })

-- Icons (needed by many plugins — load eagerly)
require("mini.icons").setup({})

-- Statusline
require("aerial").setup({
	backends = { "lsp", "treesitter", "markdown" },
	attach_mode = "global",
})
require("lualine").setup({
	options = {
		theme = "tokyonight",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		globalstatus = true, -- single statusline across all windows
		disabled_filetypes = { statusline = { "snacks_dashboard" } },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { { "filename", path = 1 } }, -- path=1 = relative path
		lualine_x = {
			{
				function()
					local ok, noice = pcall(require, "noice")
					if ok and noice.api.status.mode.has() then
						return noice.api.status.mode.get()
					end
					if not ok then
						return ""
					end
					local status = noice.api.statusline.mode
					if status.has() then
						return status.get()
					end
					return ""
				end,
				color = { fg = "#ff9464" },
			},
			"encoding",
			"fileformat",
			"filetype",
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	winbar = {
		lualine_c = {
			{
				"aerial",
				sep = "  ", -- separator between symbols
				sep_icon = "  ", -- separator between symbol icons
				depth = nil, -- nil = full depth
				dense = false, -- skip icons, only show names
				dense_sep = ".",
				colored = true,
			},
		},
		-- lualine_x = {
		-- 	{ "filename", path = 1 },
		-- },
	},
	inactive_winbar = {
		lualine_c = {},
		lualine_x = {
			{ "filename", path = 1 },
		},
	},
	extensions = { "aerial" },
})

require("bufferline").setup({
	options = {
		mode = "buffers",
		numbers = "none",
		close_command = function(n)
			vim.cmd("bdelete " .. n)
		end,
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(_, _, diag)
			local icons = { error = " ", warning = " " }
			local ret = (diag.error and icons.error .. diag.error or "")
				.. (diag.warning and icons.warning .. diag.warning or "")
			return vim.trim(ret)
		end,
		offsets = {
			{ filetype = "neo-tree", text = "Explorer", highlight = "Directory" },
		},
		show_buffer_close_icons = true,
		show_close_icon = false,
		separator_style = "slant", -- or "thin", "padded_slant", "slope"
	},
})

-- Noice — deferred (was VeryLazy)
defer(function()
	vim.pack.add({
		"https://github.com/MunifTanjim/nui.nvim",
		"https://github.com/folke/noice.nvim",
	})
	require("noice").setup({
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
			},
		},
		presets = { bottom_search = true, command_palette = true },
	})
end)

-- Highlight colors (#0ff, rgb(), etc.) — on file open
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("LazyLoad_Colors", { clear = true }),
	once = true,
	callback = function()
		vim.pack.add({ "https://github.com/brenoprata10/nvim-highlight-colors" })
		require("nvim-highlight-colors").setup({ render = "background" })
	end,
})
