local map = require('utils.keymap').map

require('which-key').add {
	mode = { 'n', 'v' },
	{ '[', group = 'prev' },
	{ ']', group = 'next' },
	{ 'g', group = 'goto' },
	{ '<leader><leader>', group = 'toggle' },
	{ '<leader>!', group = 'shell', icon = '' },
	{ '<leader>;', group = 'dropbar', icon = '' },
	{ '<leader>a', group = 'ai', icon = '🤖' },
	{ '<leader>r', group = 'refactor', icon = '' },
	{ '<leader>c', group = 'code' },
	{ '<leader>g', group = 'git' },
	{ '<leader>gh', group = 'hunks' },
	{ '<leader>s', group = 'search' },
	{ '<leader>u', group = 'ui' },
	{ '<leader>t', group = 'tab' },
	{ '<leader>f', group = 'file', icon = '' },
	{ '<leader>x', group = 'diagnostics/quickfix' },
	{ '<leader>y', group = 'yanky', icon = '' },
}

--#region --- EDITOR
-- Insert mode escapes
map { 'jj', '<esc>', mode = 'i' }
map { 'jk', '<esc>', mode = 'i' }

-- Add new lines without staying in insert mode
map { 'o', 'o<esc>', remap = true, desc = 'Open Line' }
map { 'O', 'O<esc>', remap = true, desc = 'Open Line Above' }

-- Indentation
map { '<', '<gv', mode = 'v', desc = 'Indent' }
map { '>', '>gv', mode = 'v', desc = 'Unindent' }

-- Move lines up/down
map { '<a-j>', [[<cmd>execute 'move .+' . v:count1<cr>==]], desc = 'Move Down' }
map { '<a-k>', [[<cmd>execute 'move .-' . (v:count1 + 1)<cr>==]], desc = 'Move Up' }
map { '<a-j>', [[<esc><cmd>m .+1<cr>==gi]], mode = 'i', desc = 'Move Down' }
map { '<a-k>', [[<esc><cmd>m .-2<cr>==gi]], mode = 'i', desc = 'Move Up' }
map { '<a-j>', [[:<c-u>execute "'<,'>move '>+" . v:count1<cr>gv=gv]], mode = 'v', desc = 'Move Down' }
map { '<a-k>', [[:<c-u>execute "'<,'>move '<-" . (v:count1 + 1)<cr>gv=gv]], mode = 'v', desc = 'Move Up' }

-- Duplicate lines
map { '<a-J>', '<cmd>t. <cr>', desc = 'Duplicate Lines Down' }
map { '<a-K>', '<cmd>t. <cr>k', desc = 'Duplicate Lines Up' }
map { '<a-J>', '<cmd>t. <cr>', mode = 'i', desc = 'Duplicate Line Down' }
map { '<a-K>', '<cmd>t. | -1 <cr>', mode = 'i', desc = 'Duplicate Line Up' }
map { '<a-J>', ":'<,'>t'><cr>gv", mode = { 'v', 's', 'x' }, desc = 'Duplicate Lines Down' }
map { '<a-K>', ":'<,'>t'><cr>gv", mode = { 'v', 's', 'x' }, desc = 'Duplicate Lines Up' }

-- Register control
map { 'x', '"_x', mode = { 'n', 's', 'x' }, desc = 'Void yank x' }
map { ',', '"_', mode = { 'n', 's', 'x', 'o' }, desc = 'Void Reigster' }
map { ',s', '"+', mode = { 'n', 's', 'x', 'o' }, desc = 'System Clipboard Register' }

-- Paste from system clipboard
map { '<c-s-v>', '"+P', mode = { 'n', 'v' }, nowait = true, desc = 'Paste from System Clipboard' }
map { '<c-s-v>', '<c-r>+', mode = { 'i', 'c' }, nowait = true, desc = 'Paste from System Clipboard' }
--#endregion

--#region --- MOVEMENT
-- Go to line start/end
map { 'H', '^', mode = { 'n', 'v', 'o' } }
map { 'L', '$', mode = { 'n', 'v', 'o' } }

-- Better "Goto Bottom"
map { 'G', 'Gzz', mode = { 'n', 'v' }, nowait = true }

-- Move by visual lines rather than physical lines
map { 'j', [[v:count == 0 ? 'gj' : 'j']], mode = { 'n', 'x' }, expr = true }
map { 'k', [[v:count == 0 ? 'gk' : 'k']], mode = { 'n', 'x' }, expr = true }

-- Move by 5 lines
map { '<c-k>', '5k', mode = { 'n', 'v' }, nowait = true }
map { '<c-j>', '5j', mode = { 'n', 'v' }, nowait = true }

-- Better search navigation (center results)
map { 'n', [['Nn'[v:searchforward].'zzzv']], expr = true, desc = 'Next Search Result' }
map { 'N', [['nN'[v:searchforward].'zzzv']], expr = true, desc = 'Prev Search Result' }
map { 'n', [['Nn'[v:searchforward].'zz']], mode = { 'x', 'o' }, expr = true, desc = 'Next Search Result' }
map { 'N', [['nN'[v:searchforward].'zz']], mode = { 'x', 'o' }, expr = true, desc = 'Prev Search Result' }
--#endregion

--#region --- WORKSPACE (WINDOWS, TABS, BUFFERS)
-- Close buffer / quit
map { '<c-q>', function() require('utils.buffer').bufremove() end, desc = 'Close buffer' }
map { 'ZZ', vim.cmd.quitall, desc = 'Close Session' }

-- Window resizing
map { '<c-a-up>', ':resize +1 <cr>', desc = 'Increase Window Height' }
map { '<c-a-down>', ':resize -1 <cr>', desc = 'Decrease Window Height' }
map { '<c-a-left>', ':vertical resize -1 <cr>', desc = 'Decrease Window Width' }
map { '<c-a-right>', ':vertical resize +1 <cr>', desc = 'Increase Window Width' }

-- Tab navigation
map { '<leader>td', '<cmd>tabclose<cr>', desc = 'Tab: Close' }
map { '<leader>tN', '<cmd>tabnew<cr>', desc = 'Tab: New' }
map { '<leader>tn', '<cmd>tabnext<cr>', desc = 'Tab: Next' }
map { '<leader>tp', '<cmd>tabprevious<cr>', desc = 'Tab: Previous' }

-- Buffer history
map { '<leader>tX', function() require('utils.buffer').history:clear() end, desc = 'Clear Buffer History' }
map { '<leader>ts', function() require('utils.buffer').history:restore() end, desc = 'Restore Buffer History' }
map { '<c-s-t>', function() require('utils.buffer').history:restore() end, desc = 'Restore Buffer History' }
map { ';S', function() require('utils.buffer').history:picker() end, desc = 'Buffer History Search' }
map { '<leader>`', ':b# <cr>', desc = 'Alternate buffer' }
--#endregion

--#region --- FILE
-- Save
map { '<c-s>', '<cmd>write<cr>', mode = { 'i', 'n', 'x', 's' }, desc = 'Save File' }

-- New / Delete
map { '<leader>fn', '<cmd>enew<cr>', desc = 'New File' }
map {
	'<leader>fd',
	function()
		local current_file = vim.fn.expand '%:p' -- Get the full path of the current file
		if current_file == '' then return Snacks.notify 'No file to delete.' end

		local confirm = vim.fn.confirm('Are you sure you want to delete this file?', '&Yes&No', 2)
		if confirm == 1 then
			os.remove(current_file)
			Snacks.notify('File deleted: ' .. current_file)
			vim.cmd 'bd!'
			return
		end

		Snacks.notify 'File deletion canceled.'
	end,
	desc = 'Delete File',
}

-- Make file executable
map { '<leader>!x', ':write | !chmod +x %<cr><cmd>e! % <cr>', desc = 'Set File Executable' }
--#endregion

--#region --- TERMINAL
map { '<c-q>', '<c-c>', mode = 'c' }
map { '<c-s-s>', '<c-\\><c-n>', mode = 't', desc = 'Terminal: Escape' }

-- Mimic CTRL-R in terminal to paste from a register
map {
	'<c-r>',
	function()
		local char_code = vim.fn.getchar()
		if type(char_code) ~= 'number' or char_code == 0 then return end
		local register = vim.fn.nr2char(char_code)
		local key_sequence = '<C-\\><C-N>"' .. register .. 'pi'
		local keycodes = vim.api.nvim_replace_termcodes(key_sequence, true, false, true)
		vim.api.nvim_feedkeys(keycodes, 'n', false)
	end,
	mode = 't',
	desc = 'Mimic CTRL-R in Terminal',
}
map {
	'<c-s-v>',
	function()
		local key_sequence = '<C-\\><C-N>"+pi'
		local keycodes = vim.api.nvim_replace_termcodes(key_sequence, true, false, true)
		vim.api.nvim_feedkeys(keycodes, 'n', false)
	end,
	mode = 't',
	desc = 'Paste from System Clipboard',
}
--#endregion

--#region --- LSP & DIAGNOSTICS
-- Format
map { '<a-F>', function() LazyVim.format.format { force = true } end, mode = { 'n', 'v', 'i' }, desc = 'Format' }

-- Diagnostics
---@param count number
---@param severity? vim.diagnostic.SeverityName
local function diag_jump(count, severity)
	local s = vim.diagnostic.severity[severity] or nil
	return function() vim.diagnostic.jump { float = true, count = count, severity = s } end
end
map { ']d', diag_jump(1), desc = 'Diagnostic: Next' }
map { '[d', diag_jump(-1), desc = 'Diagnostic: Prev' }
map { ']w', diag_jump(1, 'WARN'), desc = 'Diagnostic: Next warning' }
map { '[w', diag_jump(-1, 'WARN'), desc = 'Diagnostic: Prev warning' }
map { ']e', diag_jump(1, 'ERROR'), desc = 'Diagnostic: Next error' }
map { '[e', diag_jump(-1, 'ERROR'), desc = 'Diagnostic: Prev error' }
-- Note: <leader>x is defined in the which-key group for diagnostics/quickfix
--#endregion

--#region --- UI
map { '<leader>ui', vim.show_pos, desc = 'Inspect highlight under cursor' }
map { '<leader>um', '<cmd>delm! | delm A-Z0-9 | redraw <cr>', desc = 'Clear Marks' }

-- Clear visual noise
local function clear_noises()
	vim.cmd.nohlsearch()
	vim.cmd.diffupdate()
	pcall(vim.cmd.NoiceDismiss)
	Snacks.words.clear()
	vim.cmd.redraw()
end
map { '<leader>uc', clear_noises, desc = 'Clear Visual Noises', mode = { 'n', 'x' }, nowait = true }
map { '<c-l>', clear_noises, desc = 'Clear Visual Noises', mode = { 'n', 'i', 'x' }, nowait = true }
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
Snacks.toggle.indent():map '<leader><leader>g'
Snacks.toggle.scroll():map '<leader><leader>S'
Snacks.toggle.zoom():map '<leader><leader>w'
Snacks.toggle.zen():map '<leader><leader>z'
Snacks.toggle.inlay_hints():map '<leader><leader>H'
map { '<leader><leader>p', '', desc = '+profiler' }
Snacks.toggle.profiler():map '<leader><leader>pp'
Snacks.toggle.profiler_highlights():map '<leader><leader>ph'

Snacks.toggle
	.new({
		name = 'Rulers',
		get = function() return #vim.o.colorcolumn > 0 end,
		set = function(state) vim.opt_local.colorcolumn = state and '80,120' or '' end,
	})
	:map '<leader><leader>R'
Snacks.toggle
	.new({
		name = 'Inline Completion',
		get = function() return vim.lsp.inline_completion.is_enabled() end,
		set = function(state) vim.lsp.inline_completion.enable(state) end,
	})
	:map '<leader><leader>I'
--#endregion

--#region --- SYSTEM
map { '<f2>l', function() vim.cmd.Lazy() end, desc = 'Lazy', icon = '' }
map { '<f2>E', function() vim.cmd.LazyExtra() end, desc = 'Lazy Extras', icon = '' }
map { '<f2>i', function() vim.cmd.LspInfo() end, desc = 'LSP info', icon = '' }
map { '<f2>r', function() vim.cmd.LspRestart() end, desc = 'Restart LSP', icon = '' }
map { '<f2>m', function() vim.cmd.Mason() end, desc = 'Mason', icon = '' }
map { '<f2>f', function() vim.cmd.ConformInfo() end, desc = 'Conform', icon = '' }
map { '<f2>L', function() LazyVim.news.changelog() end, desc = 'LazyVim Changelog', icon = '' }
map { '<f2>h', function() vim.cmd.checkhealth() end, desc = 'Check Health', icon = '' }
--#endregion
