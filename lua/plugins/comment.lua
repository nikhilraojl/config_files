return {
    "numToStr/Comment.nvim",
    opts = {},
    config = function()
        -- Configure comment.nvim keymaps
        local comment_api = require("Comment.api")
        -- use ctrl+/ (which should be represented as [<C-_>] for some reason)
        -- for commenting single lines and multiple selected lines
        vim.keymap.set("n", "<C-_>", comment_api.toggle.linewise.current)
        vim.keymap.set("x", "<C-_>", comment_api.call("toggle.linewise", "g@"), { expr = true })
    end,
}
