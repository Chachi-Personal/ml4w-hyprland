vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown" },
    group = vim.api.nvim_create_augroup("Lang_Markdown", { clear = true }),
    once = true,
    callback = function()
        vim.pack.add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })
        local ok, reg = pcall(require, "mason-registry")
        if ok then
            reg.refresh(function()
                for _, p in ipairs({ "marksman", "prettier" }) do
                    local okp, pkg = pcall(reg.get_package, p)
                    if okp and not pkg:is_installed() then
                        pkg:install()
                    end
                end
            end)
        end
        vim.lsp.enable("marksman")
        local okr, rm = pcall(require, "render-markdown")
        if okr then
            rm.setup({})
        end
    end,
})
