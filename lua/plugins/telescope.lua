return {{
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {'nvim-lua/plenary.nvim', {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
    }},
    keys = {{
        '<leader>f',
        "<cmd>Telescope find_files<cr>",
        desc = "Find Files"
    }, {
        '<leader>g',
        "<cmd>Telescope live_grep<cr>",
        desc = "Greps (Search) Files"
    }},
    config = function()
        local telescope = require('telescope')

        telescope.setup({
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case"
                }
            }
        })

        -- We must load the extension after setup
        telescope.load_extension('fzf')
    end
}}
