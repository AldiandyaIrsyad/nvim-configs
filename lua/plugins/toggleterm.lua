return {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
        open_mapping = [[<C-\>]],

        direction = "float",

        float_opts = {
            border = "curved",
            winblend = 0
        },

        start_in_insert = true,
        insert_mappings = true,
        persist_size = true
    }
}
