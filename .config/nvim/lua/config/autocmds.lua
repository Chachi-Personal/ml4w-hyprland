local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight yanked text
autocmd("TextYankPost", {
	group = augroup("YankHighlight", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 100 })
	end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
	group = augroup("TrimWhitespace", { clear = true }),
	pattern = "*",
	callback = function()
		vim.cmd([[%s/\s\+$//e]])
	end,
})

-- Format on save via LSP
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		-- Only attach BufWritePre if the server actually supports formatting
		-- and doesn't already handle it via willSaveWaitUntil
		if
			not client:supports_method("textDocument/willSaveWaitUntil")
			and client:supports_method("textDocument/formatting")
		then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("lsp_format_on_save_" .. args.buf, { clear = true }),
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"help",
		"qf", -- quickfix & location list
		"man",
		"lspinfo",
		"startuptime",
		"checkhealth",
		"nofile",
		"notify", -- noice/snacks notification history
	},
	callback = function(event)
		vim.keymap.set("n", "q", "<cmd>close<CR>", {
			buffer = event.buf,
			silent = true,
			desc = "Close window",
		})
		vim.bo[event.buf].buflisted = false
	end,
})

vim.api.nvim_create_autocmd("QuitPre", {
	callback = function()
		local current_win = vim.api.nvim_get_current_win()

		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if win ~= current_win then
				local buf = vim.api.nvim_win_get_buf(win)
				local bt = vim.bo[buf].buftype
				local cfg = vim.api.nvim_win_get_config(win)
				-- If there's any real non-floating window besides ours → bail out
				if bt == "" and cfg.relative == "" then
					return
				end
			end
		end

		-- Only special windows remain besides current → close them
		vim.cmd("silent! cclose")
		vim.cmd("silent! lclose")
	end,
})
