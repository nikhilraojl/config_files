-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- netrw config
-- hide netrw_banner banner which takes 5 lines by default
vim.g.netrw_banner = 0

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make tab length fixed
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, for help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = "unnamedplus"

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 20

-- Show a coloured column at line 80
vim.opt.colorcolumn = "80"

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[e", vim.diagnostic.goto_prev, { desc = "Go to previous Diagnostic/[E]rror message" })
vim.keymap.set("n", "]e", vim.diagnostic.goto_next, { desc = "Go to next Diagnostic/[E]rror message" })
vim.keymap.set("n", "<leader>E", vim.diagnostic.open_float, { desc = "Show Diagnostic/[E]rror messages" })
vim.keymap.set("n", "<leader>El", vim.diagnostic.setloclist, { desc = "Open Diagnostic/[E]rror Quickfix [L]ist" })

-- window navigation command remaps
-- Keybinds to make split navigation easier. Use CTRL+<h/j/k/l> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- window resize remaps
-- Requires only single command to swtich instead of two
vim.keymap.set("n", "<Right>", function()
	vim.cmd({ cmd = "winc", args = { ">" }, count = 20 })
end)
vim.keymap.set("n", "<Left>", function()
	vim.cmd({ cmd = "winc", args = { "<" }, count = 20 })
end)
vim.keymap.set("n", "<Up>", function()
	vim.cmd({ cmd = "winc", args = { "+" }, count = 10 })
end)
vim.keymap.set("n", "<Down>", function()
	vim.cmd({ cmd = "winc", args = { "-" }, count = 10 })
end)
vim.keymap.set("n", "<leader>=", function()
	vim.cmd({ cmd = "winc", args = { "=" } })
end, { desc = "Make all splits of Equal[=] size" })

-- Replace the word under the current cursor position
vim.keymap.set("n", "<leader>rl", [[:s/<C-r><C-w>//g<Left><Left>]], { desc = "[R]eplace current word in [L]ine" })
vim.keymap.set(
	"n",
	"<leader>rf",
	[[:%s/<C-r><C-w>//g<Left><Left>]],
	{ desc = "[R]eplace current word in entire [F]ile" }
)

-- quickfix remaps
vim.keymap.set("n", "=", function()
	vim.api.nvim_command("cnext")
end, { desc = "Open next file in quickfix list" })
vim.keymap.set("n", "-", function()
	vim.api.nvim_command("cprev")
end, { desc = "Open previous file in quickfix list" })
vim.keymap.set("n", "<leader>qo", function()
	vim.api.nvim_command("copen")
end, { desc = "[Q]uickfix list [O]pen" })
vim.keymap.set("n", "<leader>qc", function()
	vim.api.nvim_command("cclose")
end, { desc = "[Q]uickfix list [C]lose" })

-- Wrap brackets & quotes around selection
-- "ts -> copy deleted text to register `t`
-- ( -> insert opening bracket/quote
-- <ESC>"tp -> goto normal mode paste text from register `t`
-- `] -> goto end of pasted text using this marker
-- a)<ESC> -> insert closing bracket/quote and goto normal mode
vim.keymap.set("v", "<leader>)", '"ts(<ESC>"tp`]a)<ESC>')
vim.keymap.set("v", "<leader>}", '"ts{<ESC>"tp`]a}<ESC>')
vim.keymap.set("v", "<leader>]", '"ts[<ESC>"tp`]a]<ESC>')
vim.keymap.set("v", "<leader>'", "\"ts'<ESC>\"tp`]a'<ESC>")
vim.keymap.set("v", '<leader>"', '"ts"<ESC>"tp`]a"<ESC>')
vim.keymap.set("v", "<leader>>", '"ts<<ESC>"tp`]a><ESC>')
vim.keymap.set("v", "<leader>`", '"ts`<ESC>"tp`]a`<ESC>')

-- keep cursor in the middle during jumps
vim.keymap.set("n", "<C-i>", "<C-i>zz")
vim.keymap.set("n", "<C-o>", "<C-o>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- Enter visual block mode
-- This remap avoids using default paste behaviour on many shells
vim.keymap.set("x", "<leader>vb", "<C-V>", { desc = "[V]isual [B]lock mode" })

-- Remap for deleting but not copying it to clipboard
vim.keymap.set({ "n", "v" }, "x", '"_x', { silent = true })

-- Remap netrw window
vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "Open netrw file [E]xplorer" })
vim.keymap.set("n", "<leader>le", function()
	vim.cmd.Lexplore({ bang = true, count = 20 })
end, { desc = "Open file to [LE]xplore to right" })
