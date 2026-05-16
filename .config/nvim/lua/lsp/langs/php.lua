vim.api.nvim_create_autocmd("FileType", {
	pattern = { "php", "blade" },
	group = vim.api.nvim_create_augroup("Lang_PHP", { clear = true }),
	once = true,
	callback = function()
		vim.lsp.enable("intelephense")

		vim.schedule(function()
			local ok, reg = pcall(require, "mason-registry")
			if not ok then
				return
			end
			reg.refresh(function()
				for _, p in ipairs({ "intelephense", "php-cs-fixer" }) do
					local okp, pkg = pcall(reg.get_package, p)
					if okp and not pkg:is_installed() then
						pkg:install()
					end
				end
			end)
		end)
	end,
})
