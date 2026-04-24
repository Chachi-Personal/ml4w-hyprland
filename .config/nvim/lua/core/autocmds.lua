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

vim.api.nvim_create_user_command("PackCheck", function()
	local lazy_packages = require("plugins.lazy_packages")
	local non_active = vim.iter(vim.pack.get())
		:filter(function(x)
			return not x.active and not lazy_packages.contains(x.spec.name)
		end)
		:map(function(x)
			return x.spec.name
		end)
		:totable()

	if #non_active == 0 then
		vim.notify("🆗 No non-active plugins found!", vim.log.levels.INFO)
		return
	end

	vim.print("😴 Non-active plugins :")
	print(" ")
	-- vim.print(non_active)
	for _, name in ipairs(non_active) do
		print(name)
	end

	print(" ")

	local choice = vim.fn.confirm(
		"Delete ALL non-active plugins from disk?",
		"&Yes\n&No",
		2 -- default = No
	)

	if choice == 1 then
		vim.pack.del(non_active)
		vim.notify("🗑️  Deleted " .. #non_active .. " non-active plugin(s)", vim.log.levels.INFO)
		print("Non-active plugins deleted!")
		vim.api.nvim_exec_autocmds("User", { pattern = "PackChanged" })
	else
		vim.notify("Cancelled. No plugins were deleted!", vim.log.levels.INFO)
	end
end, { desc = "List non active plugins and select to delete" })

-- lua/pack_update.lua

-- local function check_and_update()
-- 	-- offline = true: checks current state without downloading
-- 	-- force = true: skips the confirmation buffer
-- 	-- Combine both to do a dry "what's outdated" check:
-- 	vim.pack.update(nil, { offline = true, force = true })
--
-- 	-- Read the log to report what happened
-- 	local log_path = vim.fn.stdpath("log") .. "/nvim-pack.log"
-- 	local ok, lines = pcall(vim.fn.readfile, log_path)
-- 	if not ok then
-- 		return
-- 	end
--
-- 	-- Count lines that indicate an actual update (start with ">")
-- 	local count = 0
-- 	for _, line in ipairs(lines) do
-- 		if line:match("^>") then
-- 			count = count + 1
-- 		end
-- 	end
--
-- 	if count > 0 then
-- 		vim.notify(
-- 			count .. " plugin update(s) available. Run :lua vim.pack.update() to apply.",
-- 			vim.log.levels.INFO,
-- 			{ title = "vim.pack" }
-- 		)
-- 	end
-- end
--
-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	once = true,
-- 	callback = function()
-- 		vim.defer_fn(check_and_update, 1500)
-- 	end,
-- })

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TypstPdf", { clear = true }),
	pattern = "typst",
	callback = function(ev)
		local function open_pdf()
			local bufname = vim.api.nvim_buf_get_name(ev.buf)
			local root = vim.fs.root(ev.buf, { ".git" }) or vim.fn.fnamemodify(bufname, ":p:h")
			local stem = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(ev.buf), ":t:r")
			local pdf = root .. "/build/" .. stem .. ".pdf"
			if vim.fn.filereadable(pdf) == 0 then
				vim.notify("PDF not found: " .. pdf, vim.log.levels.WARN, { title = "Typst" })
				return
			end
			vim.fn.jobstart({ "xdg-open", pdf }, { detach = true })
		end
		vim.api.nvim_buf_create_user_command(ev.buf, "TypstOpenPdf", open_pdf, { desc = "Open compiled tpst PDF" })
		vim.keymap.set("n", "<F4>", open_pdf, { buffer = ev.buf, silent = true, desc = "Open typst PDF" })

		vim.api.nvim_create_user_command("ToggleTypstMath", function()
			local cfg = Snacks.image.config
			cfg.math.enabled = not cfg.math.enabled

			vim.cmd("edit")
			vim.notify(
				"Typst math rendering: " .. (cfg.math.enabled and "on" or "off"),
				vim.log.levels.INFO,
				{ title = "Typst" }
			)
		end, { desc = "Toggle Typst Inline Math Rendering" })
	end,
})
