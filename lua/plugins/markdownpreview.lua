return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
        -- If the plugin build fails at this point, try running
        -- `Lazy build markdown-preview.nvim` in command mode
        vim.fn["mkdp#util#install"]()
    end,
}
