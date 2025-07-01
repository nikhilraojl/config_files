require ("remap")
require "plugins"

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- [[Personal auto commands]]
-- Command :Vst => [V]ertical [s]plit & open [t]erminal
-- See :help nvim_create_user_command & :help nvim_command
vim.api.nvim_create_user_command("Vst", function()
	local windows = vim.fn.has("win32")
	if windows then
		vim.api.nvim_command("vsplit term://pwsh")
	else
		vim.api.nvim_command("vsplit +term")
	end
end, {})

-- Command :Pva => [P]yright [V]irtualenv [A]ctivate
-- See :help nvim_create_user_command & :help nvim_exec2
-- Needs pyright to be default python lsp
vim.api.nvim_create_user_command("Pva", function()
	vim.api.nvim_exec2("LspPyrightSetPythonPath venv/Scripts/python", {})
end, {})

-- Command :WezSplit => [Wez]term [Split] pane
-- See :help nvim_create_user_command & :help nvim_exec2
-- WHY : Sometimes in a linux shell, splitting a pane does not chdir to opened neovim project
-- automatically. This command helps with that. Needs Wezterm installed
vim.api.nvim_create_user_command("WezSplit", function()
	vim.api.nvim_exec2("!wezterm cli split-pane --right --cwd `pwd`", {})
end, {})
