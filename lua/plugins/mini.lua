return { 
    -- Collection of various small independent plugins/modules
    --  Check out: https://github.com/echasnovski/mini.nvim
    "echasnovski/mini.nvim",
    config = function()
        require("mini.statusline").setup()
    end,
}
