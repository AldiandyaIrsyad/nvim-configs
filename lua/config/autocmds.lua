---------------------------------------
-- Auto-change directory to the opened folder
---------------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local arg = vim.fn.argv(0)
        if arg and vim.fn.isdirectory(arg) == 1 then
            vim.api.nvim_set_current_dir(arg)
        end
    end
})
