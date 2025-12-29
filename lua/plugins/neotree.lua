return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {"nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim"},
    keys = {{
        "<C-s>",
        "<cmd>Neotree toggle<cr>",
        desc = "Toggle File Tree"
    }},
    opts = {
        filesystem = {
            filtered_items = {
                visible = false,
                hide_dotfiles = false,
                hide_gitignored = true
            },
            follow_current_file = {
                enabled = true
            },
            hijack_netrw_behavior = "open_default"
        },
        window = {
            position = "left",
            width = 30
        }
    }
}
