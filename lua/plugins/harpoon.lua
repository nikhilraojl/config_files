return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup({
            settings = {
                -- for persisting b/w restarts after modifying stuff in quick menu ui
                save_on_toggle = true,
            },
        })
        -- harpoon keymaps
        vim.keymap.set("n", "<leader>i", function()
            harpoon:list():add()
        end, { desc = "[I]nsert file to harpoon" })
        vim.keymap.set("n", "<leader>m", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Toggle harpoon quick [M]enu" })
        vim.keymap.set("n", "<leader>1", function()
            harpoon:list():select(1)
        end, { desc = "Goto [1] harpoon file" })
        vim.keymap.set("n", "<leader>2", function()
            harpoon:list():select(2)
        end, { desc = "Goto [2] harpoon file" })
        vim.keymap.set("n", "<leader>3", function()
            harpoon:list():select(3)
        end, { desc = "Goto [3] harpoon file" })
        vim.keymap.set("n", "<leader>4", function()
            harpoon:list():select(4)
        end, { desc = "Goto [4] harpoon file" })
    end,
}
