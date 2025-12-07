return { 
    "lewis6991/gitsigns.nvim",
    opts = {
        signs = {
            add = { text = "+" },
            change = { text = "~" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
            vim.keymap.set(
                "n",
                "[d",
                require("gitsigns").prev_hunk,
                { buffer = bufnr, desc = "Go to previous [D]iff" }
            )
            vim.keymap.set("n", "]d", require("gitsigns").next_hunk, { buffer = bufnr, desc = "Go to next [D]iff" })
            vim.keymap.set(
                "n",
                "<leader>sd",
                require("gitsigns").preview_hunk,
                { buffer = bufnr, desc = "[S]how Preview [D]iff" }
            )
            vim.keymap.set("n", "<leader>sb", function()
                require("gitsigns").blame_line({ full = true })
            end, { buffer = bufnr, desc = "[S]how [B]lame" })
        end,
    },
}
