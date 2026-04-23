local map = vim.keymap.set
local opt = { noremap = true, silent = true }

-- Quick Exit (Pager Style)
map("n", "q", "<cmd>quit!<cr>", opt)
map("n", "<c-q>", "<cmd>quitall!<cr>", opt)
map("n", "<c-c>", "<cmd>quitall!<cr>", opt)
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

-- Move by visual lines rather than physical lines
map({ "n", "v" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true })
map({ "n", "v" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true })

-- Faster vertical movement (5 lines at a time)
map({ "n", "v" }, "<c-k>", "5k", { nowait = true })
map({ "n", "v" }, "<c-j>", "5j", { nowait = true })

-- Better search navigation (center results)
map("n", "n", [['Nn'[v:searchforward].'zzzv']], { expr = true, desc = "Next Search Result" })
map("n", "N", [['nN'[v:searchforward].'zzzv']], { expr = true, desc = "Prev Search Result" })
map({ "x", "o" }, "n", [['Nn'[v:searchforward].'zz']], { expr = true, desc = "Next Search Result" })
map({ "x", "o" }, "N", [['nN'[v:searchforward].'zz']], { expr = true, desc = "Prev Search Result" })

-- Window resizing
map("n", "<c-a-up>", ":resize +1 <cr>", { desc = "Increase Window Height" })
map("n", "<c-a-down>", ":resize -1 <cr>", { desc = "Decrease Window Height" })
map("n", "<c-a-left>", ":vertical resize -1 <cr>", { desc = "Decrease Window Width" })
map("n", "<c-a-right>", ":vertical resize +1 <cr>", { desc = "Increase Window Width" })

-- Pane Navigation
local function pane_nav(dir)
	return function()
		return vim.schedule(function()
			vim.cmd.wincmd(dir)
		end)
	end
end
map({ "i", "n", "t" }, "<a-H>", pane_nav("h"), { desc = "Go to Left Window", expr = true })
map({ "i", "n", "t" }, "<a-J>", pane_nav("j"), { desc = "Go to Lower Window", expr = true })
map({ "i", "n", "t" }, "<a-K>", pane_nav("k"), { desc = "Go to Upper Window", expr = true })
map({ "i", "n", "t" }, "<a-L>", pane_nav("l"), { desc = "Go to Right Window", expr = true })

-- Disable insert/change keys in normal mode for the pager
local disabled_keys = { "i", "I", "a", "A", "o", "O", "c", "C", "s", "S", "r", "R" }
for _, key in ipairs(disabled_keys) do
	vim.keymap.set("n", key, "<nop>", { noremap = true, silent = true })
end
