-- State tracking
local state = {
    docker_buf = -1,
    app_buf = -1,
    docker_win = -1,
    app_win = -1
}

local function is_valid(id, type)
    if type == 'win' then
        return id and id ~= -1 and vim.api.nvim_win_is_valid(id)
    end
    if type == 'buf' then
        return id and id ~= -1 and vim.api.nvim_buf_is_valid(id)
    end
end

local function setup_window(win_id)
    if is_valid(win_id, 'win') then
        vim.api.nvim_win_set_option(win_id, "winfixwidth", true)
        vim.api.nvim_win_set_option(win_id, "number", false)
        vim.api.nvim_win_set_option(win_id, "relativenumber", false)
    end
end

_G.DevOpen = function()
    -- Docker
    if not is_valid(state.docker_win, 'win') then
        vim.cmd("botright 40vsplit")
        state.docker_win = vim.api.nvim_get_current_win()
        setup_window(state.docker_win)
    end

    if is_valid(state.docker_buf, 'buf') then
        vim.api.nvim_win_set_buf(state.docker_win, state.docker_buf)
    else
        vim.api.nvim_set_current_win(state.docker_win)
        vim.cmd("terminal while true; do echo '[LOGS] Docker-compose up...'; sleep 3; done")
        state.docker_buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_name(state.docker_buf, "Mock_Docker")
        vim.bo[state.docker_buf].bufhidden = "hide"
    end

    -- Mise
    if not is_valid(state.app_win, 'win') then
        vim.api.nvim_set_current_win(state.docker_win)
        vim.cmd("split")
        vim.cmd("resize 12")
        state.app_win = vim.api.nvim_get_current_win()
        setup_window(state.app_win)
        vim.api.nvim_win_set_option(state.app_win, "winfixheight", true)
    end

    if is_valid(state.app_buf, 'buf') then
        vim.api.nvim_win_set_buf(state.app_win, state.app_buf)
    else
        vim.api.nvim_set_current_win(state.app_win)
        vim.cmd("terminal while true; do echo '[LOGS] Mise run dev...'; sleep 3; done")
        state.app_buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_name(state.app_buf, "Mock_App")
        vim.bo[state.app_buf].bufhidden = "hide"
    end

    -- Return Focus
    vim.cmd("wincmd p");
    vim.cmd("wincmd p");
    vim.cmd("wincmd h")
end

_G.DevHide = function()
    if is_valid(state.app_win, 'win') then
        vim.api.nvim_win_close(state.app_win, true)
    end
    if is_valid(state.docker_win, 'win') then
        vim.api.nvim_win_close(state.docker_win, true)
    end
    state.docker_win = -1;
    state.app_win = -1
end

_G.DevKill = function()
    if is_valid(state.docker_buf, 'buf') then
        vim.api.nvim_buf_delete(state.docker_buf, {
            force = true
        });
        state.docker_buf = -1
    end
    if is_valid(state.app_buf, 'buf') then
        vim.api.nvim_buf_delete(state.app_buf, {
            force = true
        });
        state.app_buf = -1
    end
    _G.DevHide()
end

_G.DevToggle = function()
    if is_valid(state.docker_win, 'win') or is_valid(state.app_win, 'win') then
        _G.DevHide()
    else
        _G.DevOpen()
    end
end


vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {
    desc = "Exit Terminal Mode"
})
vim.keymap.set("t", "<A-s>", _G.DevToggle, {
    desc = "Toggle Dev Logs"
})
