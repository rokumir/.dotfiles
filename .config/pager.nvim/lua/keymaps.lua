local map = vim.keymap.set
local opt = { noremap = true, silent = true }

-- Quick Exit (Pager Style)
map("n", "q", "<cmd>quit!<cr>", opt)
map("n", "<c-q>", "<cmd>quitall!<cr>", opt)
map("n", "ZZ", "<cmd>quitall!<cr>", opt)

-- Toggle Wrap (Useful for logs/wide files)
map("n", "<a-z>", "<cmd>set wrap!<cr>", opt)

-- Clear search highlight with Escape
map("n", "<esc>", "<cmd>nohlsearch<CR><Esc>", opt)
map("n", "<c-l>", "<cmd>nohlsearch<CR><Esc>", opt)

-- Line Start/End (H/L are much faster for reading)
map({ "n", "v", "o" }, "H", "^", opt)
map({ "n", "v", "o" }, "L", "$", opt)

-- Better "Goto Bottom" (Keep cursor centered)
map({ "n", "v" }, "G", "Gzz", { noremap = true, silent = true, nowait = true })

-- Move by visual lines (gj/gk) unless a count is provided (e.g., 10j)
map({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true })
map({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true })

-- Faster vertical movement (5 lines at a time)
map({ "n", "v" }, "<c-k>", "5k", { nowait = true })
map({ "n", "v" }, "<c-j>", "5j", { nowait = true })

-- Next/Prev result + center screen (zz) + open folds (zv)
map("n", "n", [['Nn'[v:searchforward].'zzzv']], { expr = true, desc = "Next Search Result" })
map("n", "N", [['nN'[v:searchforward].'zzzv']], { expr = true, desc = "Prev Search Result" })
-- Visual/Operator modes don't need 'zv'
map({ "x", "o" }, "n", [['Nn'[v:searchforward].'zz']], { expr = true, desc = "Next Search Result" })
map({ "x", "o" }, "N", [['nN'[v:searchforward].'zz']], { expr = true, desc = "Prev Search Result" })

-- Escaping command line with Ctrl-Q
map("c", "<c-q>", "<c-c>", { desc = "Quit CommandLine" })

-- System Clipboard Helpers (mapping to the '+' register)
local clip_modes = { "o", "n", "s", "x" }
map(clip_modes, ",s", '"+', { nowait = true, desc = "System Clipboard Register" })
map(clip_modes, ",sp", '"+p', { nowait = true, desc = "Paste from System Clipboard" })
map(clip_modes, ",sP", '"+P', { nowait = true, desc = "Paste from System Clipboard (Before)" })
