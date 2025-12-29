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

---------------------------------------
-- Logs development environment Setup
---------------------------------------

local state = {
    docker_buf = -1,
    app_buf = -1,
    docker_win = -1,
    app_win = -1
}
local function is_valid_buf(bufnr)
    return bufnr and bufnr ~= -1 and vim.api.nvim_buf_is_valid(bufnr)
end

local function is_valid_win(winnr)
    return winnr and winnr ~= -1 and vim.api.nvim_win_is_valid(winnr)
end

local function setup_window(win_id)
    if is_valid_win(win_id) then
        vim.api.nvim_win_set_option(win_id, "winfixwidth", true)
        vim.api.nvim_win_set_option(win_id, "number", false)
        vim.api.nvim_win_set_option(win_id, "relativenumber", false)
    end
end

-- OPEN VIEW
local function open_dev_environment()
    -- Docker
    if not is_valid_win(state.docker_win) then
        vim.cmd("botright 40vsplit") -- Create the column
        state.docker_win = vim.api.nvim_get_current_win()
        setup_window(state.docker_win)
    end

    if is_valid_buf(state.docker_buf) then
        vim.api.nvim_win_set_buf(state.docker_win, state.docker_buf)
    else
        vim.api.nvim_set_current_win(state.docker_win)
        vim.cmd("terminal while true; do echo '[LOGS] Docker-compose up...'; sleep 3; done")
        state.docker_buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_name(state.docker_buf, "Mock_Docker")
        vim.bo[state.docker_buf].bufhidden = "hide"
    end

    -- Mise
    if not is_valid_win(state.app_win) then
        vim.api.nvim_set_current_win(state.docker_win)
        vim.cmd("split")
        vim.cmd("resize 12")
        state.app_win = vim.api.nvim_get_current_win()
        setup_window(state.app_win)
        vim.api.nvim_win_set_option(state.app_win, "winfixheight", true)
    end

    if is_valid_buf(state.app_buf) then
        vim.api.nvim_win_set_buf(state.app_win, state.app_buf)
    else
        vim.api.nvim_set_current_win(state.app_win)
        vim.cmd("terminal while true; do echo '[LOGS] Mise run dev...'; sleep 3; done")
        state.app_buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_name(state.app_buf, "Mock_App")
        vim.bo[state.app_buf].bufhidden = "hide"
    end

    -- Return Focus
    vim.cmd("wincmd p")
    vim.cmd("wincmd p")
    vim.cmd("wincmd h")
end

-- HIDE VIEW 
local function hide_dev_environment()
    if is_valid_win(state.app_win) then
        vim.api.nvim_win_close(state.app_win, true)
    end

    if is_valid_win(state.docker_win) then
        vim.api.nvim_win_close(state.docker_win, true)
    end

    state.docker_win = -1
    state.app_win = -1
end

-- KILL PROCESSES
local function kill_dev_environment()
    if is_valid_buf(state.docker_buf) then
        vim.api.nvim_buf_delete(state.docker_buf, {
            force = true
        })
        state.docker_buf = -1
        print("Stopped Docker.")
    end
    if is_valid_buf(state.app_buf) then
        vim.api.nvim_buf_delete(state.app_buf, {
            force = true
        })
        state.app_buf = -1
        print("Stopped App.")
    end
    hide_dev_environment()
end

-- TOGGLE LOGIC 
local function toggle_dev_ui()
    if is_valid_win(state.docker_win) or is_valid_win(state.app_win) then
        hide_dev_environment()
    else
        open_dev_environment()
    end
end

local function restart_dev_environment()
    kill_dev_environment()
    open_dev_environment()
end

-- MAPPINGS
vim.keymap.set("n", "<A-s>", toggle_dev_ui, {
    desc = "Toggle Dev Logs"
})
vim.keymap.set("n", "<leader>devs", open_dev_environment, {
    desc = "Dev Start"
})
vim.keymap.set("n", "<leader>devk", kill_dev_environment, {
    desc = "Dev Kill"
})
vim.keymap.set("n", "<leader>devr", restart_dev_environment, {
    desc = "Dev Restart"
})

-- User Commands
vim.api.nvim_create_user_command("DevStart", open_dev_environment, {})
vim.api.nvim_create_user_command("DevStop", kill_dev_environment, {})
vim.api.nvim_create_user_command("DevRestart", restart_dev_environment, {})

-- Directory Auto-CMD
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local arg = vim.fn.argv(0)
        if arg and vim.fn.isdirectory(arg) == 1 then
            vim.api.nvim_set_current_dir(arg)
        end
    end
})

-- Fix 
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {
    desc = "Exit Terminal Mode"
})
vim.keymap.set("t", "<A-s>", toggle_dev_ui, {
    desc = "Toggle Dev Logs"
})
