-- [[ Install `lazy.nvim` plugin manager ]]
-- See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

return require("lazy").setup({
    {import = "plugins.blink"},
    {import = "plugins.comment"},
    {import = "plugins.gitsigns"},
    {import = "plugins.guess_indent"},
    {import = "plugins.harpoon"},
    {import = "plugins.markdownpreview"},
    {import = "plugins.mini"},
    {import = "plugins.nvim_treesitter"},
    {import = "plugins.todo_comments"},
    {import = "plugins.telescope"},
    {import = "plugins.which_key"},

    -- themes
    -- switch themes using :colorscheme <name>
    -- See `:help colorscheme`
    {import = "plugins.themes.everforest"},
    {import = "plugins.themes.onedark"},
    -- themes
    --
    -- LSP
    {import = "plugins.lsps.mason"},
    {import = "plugins.lsps.mason_lspconfig"},
    {import = "plugins.lsps.nvim_lspconfig"},
})
