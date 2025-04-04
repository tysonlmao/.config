local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Map Ctrl+P to open Telescope file finder
map('n', '<C-p>', ':Telescope find_files<CR>', opts)

-- Map Ctrl+F to search inside files
map('n', '<C-f>', ':Telescope live_grep<CR>', opts)

-- Example: Map space + w to save file
map('n', '<leader>w', ':w<CR>', opts)

