local map = require('utils.keymap').map

map { 'K', '<nop>', mode = { 'n', 's', 'x' } }

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

map { 'zO', '<cmd>set foldlevel=99 <cr>', nowait = true }
map { 'zC', '<cmd>set foldlevel=0 <cr>', nowait = true }

-- Better Next/Prev (https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n)
map { 'n', [['Nn'[v:searchforward].'zzzv']], expr = true, desc = 'Next Search Result' }
map { 'N', [['nN'[v:searchforward].'zzzv']], expr = true, desc = 'Prev Search Result' }
map { 'n', [['Nn'[v:searchforward].'zz']], mode = { 'x', 'o' }, expr = true, desc = 'Next Search Result' }
map { 'N', [['nN'[v:searchforward].'zz']], mode = { 'x', 'o' }, expr = true, desc = 'Prev Search Result' }

------------------------------
--- Editor
-- map { '<c-q>', function() pcall(vim.cmd.bwipeout) end, desc = 'Close Buffer' }
map { '<c-q>', function() pcall(vim.cmd.close) end, desc = 'Close' }
map { 'ZZ', vim.cmd.quitall, desc = 'Close Session' }
map { '<c-s>', '<cmd>write<cr><esc>', mode = { 'i', 'x', 'n', 's' }, desc = 'Save File' }

map { 'o', 'o<esc>', remap = true, desc = 'Open Line' }
map { 'O', 'O<esc>', remap = true, desc = 'Open Line Above' }
map { 'p', 'P', remap = true, mode = 'v', desc = 'Paste Line' }

map { '+', '<c-a>', mode = { 'n', 'v' }, desc = 'Increase Number' }
map { '-', '<c-x>', mode = { 'n', 'v' }, desc = 'Decrease Number' }

map { '<', '<gv', mode = 'v', desc = 'Indent' }
map { '>', '>gv', mode = 'v', desc = 'Unindent' }

-- map { '<leader>sr', [[:%s/\<<c-r><c-w>\>/<c-r><c-w> /gc<c-left><bs>]], desc = 'Replace Word Under Cursor', silent = false }

------------------------------
--- UI
map { '<leader>ui', vim.show_pos, desc = 'Inspect highlight under cursor' }
map { '<leader>um', ':delm! | delm a-zA-Z <cr>', desc = 'Clear Marks in Active Buffer' }
local function clear_ui_noises()
	vim.cmd.nohlsearch() -- Clear the search highlighting
	vim.cmd.diffupdate() -- Redraw the screen
	vim.cmd.redraw() -- Update the diff highlighting and folds.
	pcall(vim.cmd.NoiceDismiss) -- Clear noice mini view
	-- pcall(require('notify').dismiss, { silent = true, pending = true }) -- Clear notifications
	Snacks.words.clear()
end
map { '<leader>uc', clear_ui_noises, desc = 'Clear Visual Noises', nowait = true }
map { '<c-l>', clear_ui_noises, desc = 'Clear Visual Noises', mode = { 'n', 'i' }, nowait = true }

---- Toggles
LazyVim.format.snacks_toggle():map '<leader><leader>f'
LazyVim.format.snacks_toggle(true):map '<leader><leader>F'
Snacks.toggle.option('spell'):map '<leader><leader>s'
Snacks.toggle.option('wrap'):map '<a-z>'
Snacks.toggle.line_number():map '<leader><leader>n'
Snacks.toggle.option('relativenumber'):map '<leader><leader>r'
Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 3, name = 'Conceal' }):map '<leader><leader>c'
Snacks.toggle.treesitter():map '<leader><leader>T'
Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader><leader>b'
Snacks.toggle.dim():map '<leader><leader>D'
Snacks.toggle.diagnostics():map '<leader><leader>d'
Snacks.toggle.animate():map '<leader><leader>m'
Snacks.toggle.indent():map '<leader><leader>g'
Snacks.toggle.scroll():map '<leader><leader>S'
Snacks.toggle.profiler():map '<leader><leader>pp'
Snacks.toggle.profiler_highlights():map '<leader><leader>ph'
Snacks.toggle.zoom():map '<leader><leader>w'
Snacks.toggle.zen():map '<leader><leader>z'

if vim.lsp.inlay_hint then Snacks.toggle.inlay_hints():map '<leader><leader>H' end

-- commands
map { '<leader>!x', ':write | !chmod +x %<cr><cmd>e! % <cr>', desc = 'Set File Executable' }

-- register
map { 'x', '"_x', mode = { 'n', 's', 'x' }, desc = 'Void yank x' }
map { ',', '"_', mode = { 'n', 's', 'x', 'o' }, desc = 'Void Reigster' }
map { ',s', '"+', mode = { 'n', 's', 'x', 'o' }, desc = 'System Clipboard Register' }

-- move lines
map { '<a-j>', [[<cmd>execute 'move .+' . v:count1<cr>==]], desc = 'Move Down' }
map { '<a-k>', [[<cmd>execute 'move .-' . (v:count1 + 1)<cr>==]], desc = 'Move Up' }
map { '<a-j>', [[<esc><cmd>m .+1<cr>==gi]], mode = 'i', desc = 'Move Down' }
map { '<a-k>', [[<esc><cmd>m .-2<cr>==gi]], mode = 'i', desc = 'Move Up' }
map { '<a-j>', [[:<c-u>execute "'<,'>move '>+" . v:count1<cr>gv=gv]], mode = 'v', desc = 'Move Down' }
map { '<a-k>', [[:<c-u>execute "'<,'>move '<-" . (v:count1 + 1)<cr>gv=gv]], mode = 'v', desc = 'Move Up' }

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
map { '<c-s-right>', ':tabnext <cr>', desc = 'Next Tab' }
map { '<c-s-left>', ':tabprev <cr>', desc = 'Prev Tab' }
-- map { '<leader><tab>d', ':tabclose <cr>', desc = 'Close Tab' }
-- map { '<c-s-right>', ':tabm +1 <cr>', desc = 'Move Tab Right' }
-- map { '<c-s-left>', ':tabm -1 <cr>', desc = 'Move Tab Left' }
------------------------------
--- Buffers (use like tab)
map { '<tab>', ':bnext <cr>', desc = 'Next Buffer' }
map { '<s-tab>', ':bprevious <cr>', desc = 'Prev Buffer' }
map { '<leader>`', ':b# <cr>', desc = 'Alternate buffer' }
map { '<leader>bd', ':bwipeout <cr>', desc = 'Delete Buffer' }
map { '<c-q>', ':bwipeout <cr>', desc = 'Delete Buffer' }
map { '<leader>bD', ':%bd | e# <cr>', desc = 'Delete all buffers except active buffer.' }

------------------------------
--- Providers/Info
map { '<leader>ll', '<cmd>Lazy <cr>', desc = 'Lazy Menu' }
map { '<leader>lm', '<cmd>Mason <cr>', desc = 'Mason Menu' }
map { '<leader>lf', '<cmd>ConformInfo <cr>', desc = 'Conform Info' }
map { '<leader>li', '<cmd>LspInfo <cr>', desc = 'Lsp Info' }
map { '<leader>lI', '<cmd>LspRestart <cr>', desc = 'Restart Lsp' }

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
