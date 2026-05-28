vim.pack.add({
	"https://github.com/mfussenegger/nvim-dap",

	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/theHamsta/nvim-dap-virtual-text",
})

local dap = require("dap")
local ui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")

dap_virtual_text.setup()

local ok, reg = pcall(require, "mason-registry")
if ok then
	reg.refresh(function()
		for _, p in ipairs({ "cpptools" }) do
			local okp, pkg = pcall(reg.get_package, p)
			if okp and not pkg:is_installed() then
				pkg:install()
			end
		end
	end)
end

local cpptools_path = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7"

dap.adapters.cppdbg = {
	type = "executable",
	id = "cppdbg",
	command = cpptools_path,
}

-- Configurations
dap.configurations = {
	c = {
		{
			name = "Launch file",
			type = "cppdbg",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopAtEntry = false,
			MIMode = "gdb",
			miDebuggerPath = "/usr/bin/gdb",
		},
		{
			name = "Attach to lldbserver :1234",
			type = "cppdbg",
			request = "launch",
			MIMode = "lldb",
			miDebuggerServerAddress = "localhost:1234",
			miDebuggerPath = "/usr/bin/lldb",
			cwd = "${workspaceFolder}",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
		},
	},
}

ui.setup()

vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

dap.listeners.before.attach.dapui_config = function()
	ui.open()
end
dap.listeners.before.launch.dapui_config = function()
	ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	ui.close()
end

local map = vim.keymap.set
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
map("n", "<leader>dc", dap.continue, { desc = "Continue" })
map("n", "<leader>di", dap.step_into, { desc = "Step Into" })
map("n", "<leader>do", dap.step_over, { desc = "Step Over" })
map("n", "<leader>du", dap.step_out, { desc = "Step Out" })
map("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
map("n", "<leader>d<CR>", dap.run_last, { desc = "Run Last" })
map("n", "<leader>dq", function()
	dap.terminate()
	ui.close()
	dap_virtual_text.toggle()
end, { desc = "Terminate" })
map("n", "<leader>dl", dap.list_breakpoints, { desc = "List Breakpoints" })
map("n", "<leader>de", function()
	dap.set_exception_breakpoints({ "all" })
end, { desc = "Set Excetion Breakpoints" })
