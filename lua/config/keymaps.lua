local map = vim.keymap.set


map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear Highlight" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit Terminal Mode" })
map({ "n", "t" }, "<A-s>", function() _G.DevToggle() end, { desc = "Toggle Dev Logs" })
map("n", "<leader>devs", function() _G.DevOpen() end, { desc = "Dev Start" })
map("n", "<leader>devk", function() _G.DevKill() end, { desc = "Dev Kill" })
map("n", "<leader>devr", function() _G.DevKill(); _G.DevOpen() end, { desc = "Dev Restart" })