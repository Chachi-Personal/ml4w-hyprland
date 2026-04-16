local aug = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd
local defer = vim.schedule

-- Treesitter — eager (syntax highlighting needed immediately)
vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	"https://github.com/windwp/nvim-ts-autotag",
})
-- Install parsers explicitly (replaces ensure_installed)
require("nvim-treesitter")
	.install({
		"lua",
		"python",
		"typescript",
		"javascript",
		"tsx",
		"rust",
		"c",
		"cpp",
		"bash",
		"nix",
		"markdown",
		"markdown_inline",
		"html",
		"css",
		"typst",
		"regex",
	})
	:wait() -- wait = install synchronously on first run
-- Highlighting is now native — enable via autocmd
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TS_Highlight", { clear = true }),
	callback = function(ev)
		local ok = pcall(vim.treesitter.start, ev.buf)
		if not ok then
			return
		end -- no parser for this filetype, silently skip
	end,
})
-- Indentation via native treesitter
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TS_Indent", { clear = true }),
	callback = function(ev)
		local ok = pcall(function()
			vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end)
	end,
})
-- Textobjects (still configured via the plugin)
require("nvim-treesitter-textobjects").setup({
	select = {
		enable = true,
		lookahead = true,
		keymaps = {
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["ac"] = "@class.outer",
			["ic"] = "@class.inner",
			["aa"] = "@parameter.outer",
			["ia"] = "@parameter.inner",
		},
	},
	move = {
		enable = true,
		set_jumps = true,
		goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
		goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
	},
})

-- nvim-ts-autotag unchanged
require("nvim-ts-autotag").setup({
	opts = {
		enable_close = true,
		enable_rename = true,
		enable_close_on_slash = true,
	},
})

-- Autopairs — on file open
au({ "BufReadPre", "BufNewFile" }, {
	group = aug("LazyLoad_Autopairs", { clear = true }),
	once = true,
	callback = function()
		vim.pack.add({ "https://github.com/windwp/nvim-autopairs" })
		require("nvim-autopairs").setup({})
	end,
})

-- Surround, Flash, better-escape — deferred (were VeryLazy)
defer(function()
	vim.pack.add({
		"https://github.com/kylechui/nvim-surround",
		"https://github.com/folke/flash.nvim",
	})
	require("nvim-surround").setup({})
	require("flash").setup({})
	local map = vim.keymap.set

	map("n", "zk", function()
		require("flash").jump()
	end, { desc = "Flash" })
end)

-- Guess indent — on file open
au({ "BufReadPre", "BufNewFile" }, {
	group = aug("LazyLoad_Indent", { clear = true }),
	once = true,
	callback = function()
		vim.pack.add({ "https://github.com/nmac427/guess-indent.nvim" })
		require("guess-indent").setup({})
	end,
})

-- -- Smart splits — deferred
-- defer(function()
-- 	vim.pack.add({ "https://github.com/mrjones2014/smart-splits.nvim" })
-- 	require("smart-splits").setup({})
-- end)
