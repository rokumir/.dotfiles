local map = require('nihil.keymap').map

map { 'K', '<nop>' }

map { 'jj', '<esc>', mode = 'i' }
map { 'jk', '<esc>', mode = 'i' }
map { '<c-q>', '<c-c>', mode = 'c' }
map { '<c-a>', 'ggVG' }
map { 'H', '^', mode = { 'n', 'v', 'o' } }
map { 'L', '$', mode = { 'n', 'v', 'o' } }

map { 'G', 'Gzz', mode = { 'n', 'v' }, nowait = true }

-- better up/down
map { 'j', [[v:count == 0 ? 'gj' : 'j']], mode = { 'n', 'x' }, expr = true }
map { 'k', [[v:count == 0 ? 'gk' : 'k']], mode = { 'n', 'x' }, expr = true }

map { '<c-k>', '5kzz', mode = { 'n', 'v' }, nowait = true }
map { '<c-j>', '5jzz', mode = { 'n', 'v' }, nowait = true }

-- Better Next/Prev (https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n)
map { 'n', [['Nn'[v:searchforward].'zzzv']], expr = true, desc = 'Next Search Result' }
map { 'N', [['nN'[v:searchforward].'zzzv']], expr = true, desc = 'Prev Search Result' }
map { 'n', [['Nn'[v:searchforward].'zz']], mode = { 'x', 'o' }, expr = true, desc = 'Next Search Result' }
map { 'N', [['nN'[v:searchforward].'zz']], mode = { 'x', 'o' }, expr = true, desc = 'Prev Search Result' }

------------------------------
--- Editor
map { '<c-q>', function() pcall(vim.cmd.bwipeout) end, desc = 'Close Buffer' }
map { 'ZZ', vim.cmd.quitall, desc = 'Close Session' }
map { '<c-s>', '<cmd>write<cr><esc>', mode = { 'i', 'x', 'n', 's' }, desc = 'Save File' }

map { 'o', 'o<esc>', remap = true, desc = 'Open Line' }
map { 'O', 'O<esc>', remap = true, desc = 'Open Line Above' }
map { 'p', 'P', remap = true, mode = 'v', desc = 'Paste Line' }

map { '+', '<c-a>', mode = { 'n', 'v' }, desc = 'Increase Number' }
map { '-', '<c-x>', mode = { 'n', 'v' }, desc = 'Decrease Number' }

map { '<', '<gv', mode = 'v', desc = 'Indent' }
map { '>', '>gv', mode = 'v', desc = 'Unindent' }

map { '<leader>sr', [[:%s/\<<c-r><c-w>\>/<c-r><c-w> /gc<c-left><bs>]], desc = 'Replace Word Under Cursor', silent = false }

------------------------------
--- UI
map { '<leader>ui', vim.show_pos, desc = 'Inspect highlight under cursor' }
map { '<leader>um', ':delm! | delm a-zA-Z <cr>', desc = 'Clear Marks in Active Buffer' }
local function clear_ui_noises()
	vim.cmd.nohlsearch() -- Clear the search highlighting
	vim.cmd.diffupdate() -- Redraw the screen
	vim.cmd.redraw() -- Update the diff highlighting and folds.
	pcall(vim.cmd.NoiceDismiss) -- Clear noice mini view
	pcall(require('notify').dismiss, { silent = true, pending = true }) -- Clear notifications
end
map { '<leader>uc', clear_ui_noises, desc = 'Clear Visual Noises', nowait = true }
map { '<c-l>', clear_ui_noises, desc = 'Clear Visual Noises', mode = { 'n', 'i' }, nowait = true }

---- Toggles
LazyVim.toggle.map('<leader><leader>f', LazyVim.toggle.format())
LazyVim.toggle.map('<leader><leader>F', LazyVim.toggle.format(true))
LazyVim.toggle.map('<leader><leader>s', LazyVim.toggle('spell', { name = 'Spelling' }))
LazyVim.toggle.map('<a-z>', LazyVim.toggle('wrap', { name = 'Wrap' }))
LazyVim.toggle.map('<leader><leader>w', LazyVim.toggle('wrap', { name = 'Wrap' }))
LazyVim.toggle.map('<leader><leader>r', LazyVim.toggle('relativenumber', { name = 'Relative Number' }))
LazyVim.toggle.map('<leader><leader>d', LazyVim.toggle.diagnostics)
LazyVim.toggle.map('<leader><leader>n', LazyVim.toggle.number)
LazyVim.toggle.map('<leader><leader>c', LazyVim.toggle('conceallevel', { values = { 0, vim.o.conceallevel > 0 and vim.o.conceallevel or 2 } }))
LazyVim.toggle.map('<leader><leader>T', LazyVim.toggle.treesitter)
if vim.lsp.inlay_hint then LazyVim.toggle.map('<leader><leader>H', LazyVim.toggle.inlay_hints) end

-- commands
map { '<leader>!x', ':write | !chmod +x %<cr><cmd>e! % <cr>', desc = 'Set File Executable' }

-- register
map { 'x', '"_x', mode = { 'n', 's', 'x' }, desc = 'Void yank x' }
map { ',', '"_', mode = { 'n', 's', 'x', 'o' }, desc = 'Void Reigster' }
map { ',s', '"+', mode = { 'n', 's', 'x', 'o' }, desc = 'System Clipboard Register' }

-- move lines
map { '<a-j>', ':m .+1<cr>==', desc = 'Move Down' }
map { '<a-k>', ':m .-2<cr>==', desc = 'Move Up' }
map { '<a-j>', '<esc><cmd>m .+1<cr>==gi', mode = 'i', desc = 'Move Down' }
map { '<a-k>', '<esc><cmd>m .-2<cr>==gi', mode = 'i', desc = 'Move Up' }
map { '<a-j>', [[:m '>+1<cr>gv=gv]], mode = 'v', desc = 'Move Down' }
map { '<a-k>', [[:m '<-2<cr>gv=gv]], mode = 'v', desc = 'Move Up' }
-- duplication
map { '<a-J>', '<cmd>t. <cr>', desc = 'Duplicate Lines Down' }
map { '<a-K>', '<cmd>t. <cr>k', desc = 'Duplicate Lines Up' }
map { '<a-J>', '<cmd>t. <cr>', mode = 'i', desc = 'Duplicate Line Down' }
map { '<a-K>', '<cmd>t. | -1 <cr>', mode = 'i', desc = 'Duplicate Line Up' }
map { '<a-J>', ":'<,'>t'><cr>gv", mode = { 'v', 's', 'x' }, desc = 'Duplicate Lines Down' }
map { '<a-K>', ":'<,'>t'><cr>gv", mode = { 'v', 's', 'x' }, desc = 'Duplicate Lines Up' }

------------------------------
--- Split
map { '<c-a-up>', ':resize +1 <cr>', desc = 'Increase Window Height' }
map { '<c-a-down>', ':resize -1 <cr>', desc = 'Decrease Window Height' }
map { '<c-a-left>', ':vertical resize -1 <cr>', desc = 'Decrease Window Width' }
map { '<c-a-right>', ':vertical resize +1 <cr>', desc = 'Increase Window Width' }

------------------------------
--- Tabs
map { '<tab>', ':tabnext <cr>', desc = 'Next Tab' }
map { '<s-tab>', ':tabprev <cr>', desc = 'Prev Tab' }
map { '<leader><tab>d', ':tabclose <cr>', desc = 'Close Tab' }
map { '<c-s-right>', ':tabm +1 <cr>', desc = 'Move Tab Right' }
map { '<c-s-left>', ':tabm -1 <cr>', desc = 'Move Tab Left' }

------------------------------
--- Buffers
map { ']b', ':bnext <cr>', desc = 'Next Buffer' }
map { '[b', ':bprevious <cr>', desc = 'Prev Buffer' }
map { '<leader>`', ':b# <cr>', desc = 'Alternate buffer' }
map { '<leader>bd', ':bwipeout <cr>', desc = 'Delete Buffer' }
map { '<leader>bD', ':%bd | e# <cr>', desc = 'Delete all buffers except active buffer.' }

------------------------------
--- Providers/Info
map { '<leader>mm', '<cmd>Lazy <cr>', desc = 'Lazy Menu' }
map { '<leader>ms', '<cmd>Mason <cr>', desc = 'Mason Menu' }
map { '<leader>ml', '<cmd>LspInfo <cr>', desc = 'Lsp Info' }
map { '<leader>mf', '<cmd>ConformInfo <cr>', desc = 'Conform Info' }

------------------------------
--- Formatting
map { '<a-F>', function() LazyVim.format { force = true } end, mode = { 'n', 'v' }, desc = 'Format' }

------------------------------
--- Diagnostics
---@param severity? vim.diagnostic.Severity
local function diag_go(dir, severity)
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function() vim.diagnostic['goto_' .. dir] { severity = severity } end
end
map { ']d', diag_go 'next', desc = 'Next diagnostic' }
map { '[d', diag_go 'prev', desc = 'Prev diagnostic' }
map { ']e', diag_go('next', 'ERROR'), desc = 'Next error diagnostic' }
map { '[e', diag_go('prev', 'ERROR'), desc = 'Prev error diagnostic' }
map { ']w', diag_go('next', 'WARN'), desc = 'Next warning diagnostic' }
map { '[w', diag_go('prev', 'WARN'), desc = 'Prev warning diagnostic' }
