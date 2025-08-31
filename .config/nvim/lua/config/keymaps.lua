---@diagnostic disable: no-unknown
local map = require('utils.keymap').map
local ui_utils = require 'utils.ui'

--#region --- UNMAP
map { 'K', '<nop>', mode = { 'n', 's', 'x' } }
map { '<c-e>', '<nop>', mode = { 'i' } }
--#endregion UNMAP

--#region --- MISC
-- Movement
map { 'jj', '<esc>', mode = 'i' }
map { 'jk', '<esc>', mode = 'i' }
map { '<c-q>', '<c-c>', mode = 'c' }
-- map { '<c-a>', 'ggVG' }
map { 'H', '^', mode = { 'n', 'v', 'o' } }
map { 'L', '$', mode = { 'n', 'v', 'o' } }

-- NOTE: for tmux, neovide
map { '<c-s-v>', '"+P', mode = { 'n', 'v' }, nowait = true, desc = 'Paste from System Clipboard' }
map { '<c-s-v>', '<c-r>+', mode = { 'i', 'c' }, nowait = true, desc = 'Paste from System Clipboard' }

-- Better "Goto Bottom"
map { 'G', 'Gzz', mode = { 'n', 'v' }, nowait = true }

-- shell stuffs
map { '<leader>!x', ':write | !chmod +x %<cr><cmd>e! % <cr>', desc = 'Set File Executable' }

-- more easy/quick control over void and system register
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

-- better up/down
map { 'j', [[v:count == 0 ? 'gj' : 'j']], mode = { 'n', 'x' }, expr = true }
map { 'k', [[v:count == 0 ? 'gk' : 'k']], mode = { 'n', 'x' }, expr = true }
map { '<c-k>', '5k', mode = { 'n', 'v' }, nowait = true }
map { '<c-j>', '5j', mode = { 'n', 'v' }, nowait = true }

-- foldings
map { 'zO', '<cmd>set foldlevel=99 <cr>', nowait = true }
map { 'zC', '<cmd>set foldlevel=0 <cr>', nowait = true }

-- search
-- map { '<c-f>', '/', mode = { 'n', 'i', 's' }, remap = true }

-- Better Next/Prev (https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n)
map { 'n', [['Nn'[v:searchforward].'zzzv']], expr = true, desc = 'Next Search Result' }
map { 'N', [['nN'[v:searchforward].'zzzv']], expr = true, desc = 'Prev Search Result' }
map { 'n', [['Nn'[v:searchforward].'zz']], mode = { 'x', 'o' }, expr = true, desc = 'Next Search Result' }
map { 'N', [['nN'[v:searchforward].'zz']], mode = { 'x', 'o' }, expr = true, desc = 'Prev Search Result' }
--#endregion

--#region --- FILE
map { '<leader>f', '', desc = 'file' }

-- new file
map { '<leader>fn', '<cmd>enew<cr>', desc = 'New File' }
--#endregion

--#region --- EDITOR
map { '<c-q>', ui_utils.bufremove, desc = 'Close buffer' }
map { 'ZZ', vim.cmd.quitall, desc = 'Close Session' }
map { '<c-s>', '<cmd>write<cr><esc>', mode = { 'i', 'x', 'n', 's' }, desc = 'Save File' }

map { 'o', 'o<esc>', remap = true, desc = 'Open Line' }
map { 'O', 'O<esc>', remap = true, desc = 'Open Line Above' }
map { 'p', 'P', remap = true, mode = 'v', desc = 'Paste Line' }

-- map { '+', '<c-a>', mode = { 'n', 'v' }, desc = 'Increase Number' }
-- map { '-', '<c-x>', mode = { 'n', 'v' }, desc = 'Decrease Number' }

map { '<', '<gv', mode = 'v', desc = 'Indent' }
map { '>', '>gv', mode = 'v', desc = 'Unindent' }

-- map { '<leader>sr', [[:%s/\<<c-r><c-w>\>/<c-r><c-w> /gc<c-left><bs>]], desc = 'Replace Word Under Cursor', silent = false }
--#endregion

--#region --- UI
map { '<leader>u', '', desc = '+ui' }
map { '<leader>ui', vim.show_pos, desc = 'Inspect highlight under cursor' }
local function clearVisualNoises()
	vim.cmd.nohlsearch() -- Clear the search highlighting
	vim.cmd.diffupdate() -- Redraw the screen
	vim.cmd.redraw() -- Update the diff highlighting and folds.
	pcall(vim.cmd.NoiceDismiss) -- Clear noice mini view
	pcall(Snacks.words.clear)
end
map { '<c-l>', clearVisualNoises, desc = 'Clear Visual Noises', mode = { 'n', 'i', 'x' }, nowait = true }
map { '<leader>uc', clearVisualNoises, desc = 'Clear Visual Noises', mode = { 'n', 'x' }, nowait = true }
map { '<leader>um', '<cmd>delm! | delm A-Z0-9<cr>', desc = 'Clear Marks' }
--#endregion

--#region --- WINDOWS
-- split
map { '<c-a-up>', ':resize +1 <cr>', desc = 'Increase Window Height' }
map { '<c-a-down>', ':resize -1 <cr>', desc = 'Decrease Window Height' }
map { '<c-a-left>', ':vertical resize -1 <cr>', desc = 'Decrease Window Width' }
map { '<c-a-right>', ':vertical resize +1 <cr>', desc = 'Increase Window Width' }

-- tabs
-- map { '<leader>t', '', desc = 'tab' }
map { '<leader>td', '<cmd>tabclose<cr>', desc = 'Tab: Close' }
map { '<leader>tn', '<cmd>tabnew<cr>', desc = 'Tab: New' }
map { '<leader><tab>', '<cmd>tabnext<cr>', desc = 'Tab: Next' }
map { '<leader><s-tab>', '<cmd>tabprevious<cr>', desc = 'Tab: Previous' }
-- map { '<leader>t<', ':tabm +1 <cr>', desc = 'Move Tab Right' }
-- map { '<leader>t>', ':tabm -1 <cr>', desc = 'Move Tab Left' }

-- buffers (use like tab)
-- map { '<tab>', ':bnext <cr>', desc = 'Next Buffer' }
-- map { '<s-tab>', ':bprevious <cr>', desc = 'Prev Buffer' }
map { '<leader>`', ':b# <cr>', desc = 'Alternate buffer' }
--#endregion

if LazyVim == nil then return end

--#region --- TOGGLES
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

local colorcolumn = #vim.o.colorcolumn == 0 and '80,120' or ''
Snacks.toggle
	.new({
		name = 'Rulers',
		get = function() return #vim.o.colorcolumn > 0 end,
		set = function(state) vim.opt.colorcolumn = state and colorcolumn or '' end,
	})
	:map '<leader><leader>R'
--#endregion

--#region --- SYSTEM
map { '<f2>l', function() vim.cmd.Lazy() end, desc = 'Lazy' }
map { '<f2>E', function() vim.cmd.LazyExtra() end, desc = 'Lazy' }
map { '<f2>i', function() vim.cmd.LspInfo() end, desc = 'LSP info' }
map { '<f2>r', function() vim.cmd.LspRestart() end, desc = 'Restart LSP' }
map { '<f2>m', function() vim.cmd.Mason() end, desc = 'Mason' }
map { '<f2>f', function() vim.cmd.ConformInfo() end, desc = 'Conform' }
map { '<f2>L', function() LazyVim.news.changelog() end, desc = 'LazyVim Changelog' }
--#endregion

--#region --- LSP
map { '<a-F>', function() LazyVim.format { force = true } end, mode = { 'n', 'v' }, desc = 'Format' }

-- diagnostics
---@param count number
---@param severity? vim.diagnostic.SeverityName|vim.diagnostic.Severity
local function diag_jump(count, severity)
	if severity then severity = vim.diagnostic.severity[severity] end
	return function() vim.diagnostic.jump { float = true, count = count, severity = severity } end
end
map { ']d', diag_jump(1), desc = 'Diagnostic: Next' }
map { '[d', diag_jump(-1), desc = 'Diagnostic: Prev' }
map { ']w', diag_jump(1, 'WARN'), desc = 'Diagnostic: Next warning' }
map { '[w', diag_jump(-1, 'WARN'), desc = 'Diagnostic: Prev warning' }
map { ']e', diag_jump(1, 'ERROR'), desc = 'Diagnostic: Next error' }
map { '[e', diag_jump(-1, 'ERROR'), desc = 'Diagnostic: Prev error' }
--#endregion
