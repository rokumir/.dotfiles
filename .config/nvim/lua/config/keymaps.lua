local map = Nihil.keymap
local unmap = Nihil.keymap.unmap

-- Which-key groups register
map {
	mode = { 'n', 'v' },
	{ '[', group = 'prev' },
	{ ']', group = 'next' },
	{ 'g', group = 'goto' },
	{ ';', group = 'Snacks/Pickers', icon = '⛏️' },
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
	{ '<leader>y', group = 'yanky', icon = '' },
	{ '<leader><leader>', group = 'toggle' },
	{ '<leader><leader>p', group = 'profiler' },
	{ '<leader><leader>u', group = 'ui' },
	{ '<leader><leader>r', group = 'ui [Render Markdown]' },
	{ '<leader><leader>l', group = 'lsp/format' },
	{ '<leader><leader>o', group = 'option' },
}

unmap {
	{ '<f1>', nop = true, mode = { 'n', 'i' } },
	{ 'gra', mode = { 'n', 'x' } },
	'grr',
	'grn',
	'gri',
	'grt',
}

--#region --- EDITOR
-- Insert mode escapes
map { 'jj', '<esc>', mode = 'i' }
map { 'jk', '<esc>', mode = 'i' }

map { '<c-q>', '<c-c>', mode = 'c' }

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
map { '<c-s-j>', '<cmd>t. <cr>', desc = 'Duplicate Lines Down' }
map { '<c-s-k>', '<cmd>t. <cr>k', desc = 'Duplicate Lines Up' }
map { '<c-s-j>', '<cmd>t. <cr>', mode = 'i', desc = 'Duplicate Line Down' }
map { '<c-s-k>', '<cmd>t. | -1 <cr>', mode = 'i', desc = 'Duplicate Line Up' }
map { '<c-s-j>', ":'<,'>t'><cr>gv", mode = { 'v', 's', 'x' }, desc = 'Duplicate Lines Down' }
map { '<c-s-k>', ":'<,'>t'><cr>gv", mode = { 'v', 's', 'x' }, desc = 'Duplicate Lines Up' }

-- Register control
map { 'x', '"_x', mode = { 'n', 's', 'x' }, desc = 'Void yank x' }
map { ',', '"_', mode = { 'o', 'n', 's', 'x' }, desc = 'Void Reigster' }
map {
	nowait = true,
	mode = { 'o', 'n', 's', 'x' },
	group = 'System Clipboard Register',
	{ ',s', '"+' },
	{ ',sp', '"+p' },
	{ ',sP', '"+P' },
}

-- Paste from system clipboard
map {
	group = 'Paste from System Clipboard',
	{ '<c-s-v>', '"+P', mode = { 'n', 'v' } }, -- normal & visual
	{ '<c-s-v>', '<c-r>+', mode = { 'i', 'c' } }, -- insert & cmdline
	{ -- terminal
		'<c-s-v>',
		function()
			local key_sequence = '<C-\\><C-N>"+pi'
			local keycodes = vim.api.nvim_replace_termcodes(key_sequence, true, false, true)
			vim.api.nvim_feedkeys(keycodes, 'n', false)
		end,
		mode = 't',
	},
}
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
map { '<c-q>', function() Snacks.bufdelete.delete() end, desc = 'Safely Close Buffer' }
map { 'ZZ', vim.cmd.quitall, desc = 'Close Session' }

-- Window resizing
map { '<c-a-up>', ':resize +1 <cr>', desc = 'Increase Window Height' }
map { '<c-a-down>', ':resize -1 <cr>', desc = 'Decrease Window Height' }
map { '<c-a-left>', ':vertical resize -1 <cr>', desc = 'Decrease Window Width' }
map { '<c-a-right>', ':vertical resize +1 <cr>', desc = 'Increase Window Width' }

-- Buffer history
map { '<leader>tX', function() Nihil.file.buf_history:clear() end, desc = 'Clear Buffer History' }
map { '<leader>ts', function() Nihil.file.buf_history:restore() end, desc = 'Restore Buffer History' }
map { '<c-s-t>', function() Nihil.file.buf_history:restore() end, desc = 'Restore Buffer History' }
map { ';S', function() Nihil.file.buf_history:picker() end, desc = 'Buffer History Search' }
map { '<leader>`', ':b# <cr>', desc = 'Alternate buffer' }

-- Pane Navigation
local function nav(dir)
	return function()
		return vim.schedule(function() vim.cmd.wincmd(dir) end)
	end
end
map {
	mode = { 'i', 'n', 't' },
	expr = true,
	{ '<a-H>', nav 'h', desc = 'Go to Left Window' },
	{ '<a-J>', nav 'j', desc = 'Go to Lower Window' },
	{ '<a-K>', nav 'k', desc = 'Go to Upper Window' },
	{ '<a-L>', nav 'l', desc = 'Go to Right Window' },
}
--#endregion

--#region --- FILE
-- Save
map { '<c-s>', '<cmd>write<cr>', mode = { 'i', 'n', 'x', 's' }, desc = 'Save File' }

-- New / Delete
map { '<leader>fn', '<cmd>enew<cr>', desc = 'New File' }
map { '<leader>fd', function() Nihil.file.delete() end, desc = 'Delete File' }

-- Make file executable
map { '<leader>!x', ':write | !chmod +x %<cr><cmd>e! % <cr>', desc = 'Set File Executable' }
--#endregion

--#region --- TERMINAL
map { '<a-~>', '<cmd>term <cr>', desc = 'New Terminal' }
map { '<c-s-space>', '<c-\\><c-n>', mode = 't', desc = 'Escape Terminal' }
map { '<c-;>', '<a-|>', mode = 't', desc = 'Sendkey alt-|' }
-- map { '<c-tab>', '<c-tab>', mode = 't', desc = 'Sendkey ctrl-tab' }
-- map { '<c-s-tab>', '<c-s-tab>', mode = 't', desc = 'Sendkey ctrl-shift-tab' }

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
--#endregion

--#region --- LSP & DIAGNOSTICS
-- Format
map { '<a-F>', function() LazyVim.format.format { force = true } end, mode = { 'n', 'v', 'i' }, desc = 'Format Buffer' }

-- Diagnostics
---@param count number
---@param severity? vim.diagnostic.SeverityName
local function diag_jump(count, severity)
	local s = vim.diagnostic.severity[severity] or nil
	return function() vim.diagnostic.jump { float = true, count = count, severity = s } end
end
map { ']d', diag_jump(1), desc = 'Next Diagnostic' }
map { '[d', diag_jump(-1), desc = 'Prev Diagnostic' }
map { ']w', diag_jump(1, 'WARN'), desc = 'Next Warning Diagnostic' }
map { '[w', diag_jump(-1, 'WARN'), desc = 'Prev Warning Diagnostic' }
map { ']e', diag_jump(1, 'ERROR'), desc = 'Next Error Diagnostic' }
map { '[e', diag_jump(-1, 'ERROR'), desc = 'Prev Error Diagnostic' }
--#endregion

--#region --- UI
map { '<leader>ui', vim.show_pos, desc = 'Inspect highlight under cursor' }
map { '<leader>um', '<cmd>delm! | delm A-Z0-9 | redraw <cr>', desc = 'Clear Marks' }

-- Clear visual noise
vim.api.nvim_create_user_command('ClearUI', function()
	pcall(Snacks.words.clear)
	vim.cmd.nohlsearch()
	vim.cmd.diffupdate()
	vim.cmd.redraw()
	pcall(function() require('noice.view.backend.snacks'):dismiss() end)
end, { desc = 'Clear UI Noises' })
map {
	nowait = true,
	mode = { 'n', 'x' },
	{ '<leader>uc', '<cmd>ClearUI<cr>', desc = 'Clear Visual Noises' },
	{ '<c-l>', '<cmd>ClearUI<cr>', desc = 'Clear Visual Noises' },
}
--#endregion

if not LazyVim and not Snacks then return end

--#region --- TOGGLES
LazyVim.format.snacks_toggle():map '<leader><leader>lf'
LazyVim.format.snacks_toggle(true):map '<leader><leader>lF'
Snacks.toggle.diagnostics():map '<leader><leader>ld'
Snacks.toggle.treesitter():map '<leader><leader>lt'
Snacks.toggle.inlay_hints():map '<leader><leader>lh'

Snacks.toggle.option('spell'):map '<leader><leader>os'
Snacks.toggle.option('wrap'):map('<leader><leader>ow'):map '<a-z>'
Snacks.toggle.line_number():map '<leader><leader>on'
Snacks.toggle.option('relativenumber'):map '<leader><leader>oN'
Snacks.toggle
	.option('conceallevel', {
		off = 0,
		on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
		name = 'Conceal Level',
	})
	:map '<leader><leader>oc'
Snacks.toggle
	.new({
		name = 'Rulers',
		get = function() return #vim.o.colorcolumn > 0 end,
		set = function(state) vim.opt_local.colorcolumn = state and '80,120' or '' end,
	})
	:map '<leader><leader>or'

Snacks.toggle.dim():map '<leader><leader>ud'
Snacks.toggle.indent():map '<leader><leader>ui'
Snacks.toggle.scroll():map '<leader><leader>us'
Snacks.toggle.zen():map '<leader><leader>uz'
Snacks.toggle.zoom():map '<leader><leader>uZ'

Snacks.toggle.profiler():map '<leader><leader>pp'
Snacks.toggle.profiler_highlights():map '<leader><leader>ph'
Snacks.toggle
	.new({
		name = 'Lualine Expand DateTime',
		get = function() return vim.g.nihil_lualine_time_expanded == true end,
		set = function(state) vim.g.nihil_lualine_time_expanded = state end,
	})
	:map '<leader><leader>ud'
--#endregion

--#region --- SYSTEM
map {
	'<f2>',
	group = 'Menu',
	{ '<f2>l', '<cmd>Lazy <cr>', desc = 'Lazy', icon = '' },
	{ '<f2>E', '<cmd>LazyExtra <cr>', desc = 'Lazy Extras', icon = '' },
	{ '<f2>I', '<cmd>LspInfo <cr>', desc = 'LSP Info', icon = '' },
	{ '<f2>i', function() Snacks.picker.lsp_config() end, desc = 'Lsp Info [Snacks]', icon = '' },
	{ '<f2>r', '<cmd>LspRestart <cr>', desc = 'Restart LSP', icon = '' },
	{ '<f2>m', '<cmd>Mason <cr>', desc = 'Mason', icon = '' },
	{ '<f2>f', '<cmd>ConformInfo <cr>', desc = 'Conform', icon = '󰃢' },
	{ '<f2>h', '<cmd>checkhealth <cr>', desc = 'Check Health', icon = '' },
	{ '<f2>L', LazyVim.news.changelog, desc = 'LazyVim Changelog', icon = '' },
	{ '<f2>U', '<cmd>TSUpdate | Lazy update | MasonUpdate <cr>', desc = 'BIG Update', icon = '' },
	{
		'<f2>b',
		function()
			Snacks.terminal.get('btop', {
				cwd = vim.env.HOME,
				win = {
					ft = 'term_btop',
					minimal = true,
					position = 'float',
					relative = 'editor',
					keys = { ['<c-q>'] = { 'close', expr = true, mode = 't' } },
				},
			})
		end,
		desc = 'BTOP',
		icon = '',
	},
}
--#endregion
