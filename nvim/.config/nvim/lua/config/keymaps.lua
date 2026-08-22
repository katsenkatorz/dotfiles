-- Extra keymaps on top of LazyVim defaults:
-- https://www.lazyvim.org/keymaps
local map = vim.keymap.set

-- Keep the cursor centered while jumping half-pages / search results
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- Paste over a selection without clobbering the yank register
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })
