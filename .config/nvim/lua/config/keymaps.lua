local map = Nihil.keymap
local unmap = Nihil.keymap.unmap

unmap {
	{ '<f1>', nop = true, mode = { 'n', 'i' } },
	{ 'gra', mode = { 'n', 'x' } },
	'grr',
	'grn',
	'gri',
	'grt',
}

map { --- GROUPS
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
	{ '<f1>', '<leader><leader>', remap = true, mode = { 'n', 'i' }, group = 'toggle' },
	{ '<leader><leader>', group = 'toggle' },
	{ '<leader><leader>p', group = 'profiler' },
	{ '<leader><leader>u', group = 'ui' },
	{ '<leader><leader>r', group = 'ui [Render Markdown]' },
	{ '<leader><leader>l', group = 'lsp/format' },
	{ '<leader><leader>o', group = 'option' },
}

map { --- EDITOR
	{ 'jj', '<esc>', mode = 'i', desc = 'Escape Insert Mode' },
	{ 'jk', '<esc>', mode = 'i', desc = 'Escape Insert Mode' },
	{ '<c-q>', '<c-c>', mode = 'c', desc = 'Quit CommandLine' },

	{ 'o', 'o<esc>', remap = true, desc = 'Open Line' },
	{ 'O', 'O<esc>', remap = true, desc = 'Open Line Above' },

	{ '<', '<gv', mode = 'v', desc = 'Indent' },
	{ '>', '>gv', mode = 'v', desc = 'Unindent' },

	-- Move lines up/down
	{ '<a-j>', [[<cmd>execute 'move .+' . v:count1<cr>==]], desc = 'Move Down' },
	{ '<a-k>', [[<cmd>execute 'move .-' . (v:count1 + 1)<cr>==]], desc = 'Move Up' },
	{ '<a-j>', [[<esc><cmd>m .+1<cr>==gi]], mode = 'i', desc = 'Move Down' },
	{ '<a-k>', [[<esc><cmd>m .-2<cr>==gi]], mode = 'i', desc = 'Move Up' },
	{ '<a-j>', [[:<c-u>execute "'<,'>move '>+" . v:count1<cr>gv=gv]], mode = 'v', desc = 'Move Down' },
	{ '<a-k>', [[:<c-u>execute "'<,'>move '<-" . (v:count1 + 1)<cr>gv=gv]], mode = 'v', desc = 'Move Up' },

	-- Duplicate lines
	{ '<c-s-j>', '<cmd>t. <cr>', desc = 'Duplicate Lines Down' },
	{ '<c-s-k>', '<cmd>t. <cr>k', desc = 'Duplicate Lines Up' },
	{ '<c-s-j>', '<cmd>t. <cr>', mode = 'i', desc = 'Duplicate Line Down' },
	{ '<c-s-k>', '<cmd>t. | -1 <cr>', mode = 'i', desc = 'Duplicate Line Up' },
	{ '<c-s-j>', ":'<,'>t'><cr>gv", mode = { 'v', 's', 'x' }, desc = 'Duplicate Lines Down' },
	{ '<c-s-k>', ":'<,'>t'><cr>gv", mode = { 'v', 's', 'x' }, desc = 'Duplicate Lines Up' },

	-- Register control
	{ 'x', '"_x', mode = { 'n', 's', 'x' }, desc = 'Void yank x' },
	{ ',', '"_', mode = { 'o', 'n', 's', 'x' }, desc = 'Void Reigster' },
	{
		nowait = true,
		mode = { 'o', 'n', 's', 'x' },
		{ ',s', '"+', desc = 'System Clipboard Register' },
		{ ',sp', '"+p', desc = 'System Clipboard Register' },
		{ ',sP', '"+P', desc = 'System Clipboard Register' },
	},

	-- Paste from system clipboard
	{ '<c-s-v>', '"+P', mode = { 'n', 'v' }, desc = 'Paste from System Clipboard' },
	{ '<c-s-v>', '<c-r>+', mode = { 'i', 'c' }, desc = 'Paste from System Clipboard' },
	{ -- terminal
		'<c-s-v>',
		function()
			local key_sequence = '<C-\\><C-N>"+pi'
			local keycodes = vim.api.nvim_replace_termcodes(key_sequence, true, false, true)
			vim.api.nvim_feedkeys(keycodes, 'n', false)
		end,
		mode = 't',
		desc = 'Paste from System Clipboard',
	},
}

map { --- MOVEMENT
	-- Go to line start/end
	{ 'H', '^', mode = { 'n', 'v', 'o' } },
	{ 'L', '$', mode = { 'n', 'v', 'o' } },

	-- Better "Goto Bottom"
	{ 'G', 'Gzz', mode = { 'n', 'v' }, nowait = true },

	-- Move by visual lines rather than physical lines
	{ 'j', [[v:count == 0 ? 'gj' : 'j']], mode = { 'n', 'x' }, expr = true },
	{ 'k', [[v:count == 0 ? 'gk' : 'k']], mode = { 'n', 'x' }, expr = true },

	-- Move by 5 lines
	{ '<c-k>', '5k', mode = { 'n', 'v' }, nowait = true },
	{ '<c-j>', '5j', mode = { 'n', 'v' }, nowait = true },

	-- Better search navigation (center results)
	{ 'n', [['Nn'[v:searchforward].'zzzv']], expr = true, desc = 'Next Search Result' },
	{ 'N', [['nN'[v:searchforward].'zzzv']], expr = true, desc = 'Prev Search Result' },
	{ 'n', [['Nn'[v:searchforward].'zz']], mode = { 'x', 'o' }, expr = true, desc = 'Next Search Result' },
	{ 'N', [['nN'[v:searchforward].'zz']], mode = { 'x', 'o' }, expr = true, desc = 'Prev Search Result' },
}

map { --- WORKSPACE (WINDOWS, TABS, BUFFERS)
	{ '<c-q>', function() Snacks.bufdelete.delete() end, desc = 'Safely Close Buffer' },
	{ 'ZZ', vim.cmd.quitall, desc = 'Close Session' },

	-- Window resizing
	{ '<c-a-up>', ':resize +1 <cr>', desc = 'Increase Window Height' },
	{ '<c-a-down>', ':resize -1 <cr>', desc = 'Decrease Window Height' },
	{ '<c-a-left>', ':vertical resize -1 <cr>', desc = 'Decrease Window Width' },
	{ '<c-a-right>', ':vertical resize +1 <cr>', desc = 'Increase Window Width' },

	-- Buffer history
	{ '<leader>tX', function() Nihil.file.buf_history:clear() end, desc = 'Clear Buffer History' },
	{ '<leader>ts', function() Nihil.file.buf_history:restore() end, desc = 'Restore Buffer History' },
	{ '<c-s-t>', function() Nihil.file.buf_history:restore() end, desc = 'Restore Buffer History' },
	{ ';S', function() Nihil.file.buf_history:picker() end, desc = 'Buffer History Search' },
	{ '<leader>`', ':b# <cr>', desc = 'Alternate buffer' },

	-- Pane Navigation
	{ '<a-H>', Nihil.pane_nav 'h', desc = 'Go to Left Window', expr = true, mode = { 'i', 'n', 't' } },
	{ '<a-J>', Nihil.pane_nav 'j', desc = 'Go to Lower Window', expr = true, mode = { 'i', 'n', 't' } },
	{ '<a-K>', Nihil.pane_nav 'k', desc = 'Go to Upper Window', expr = true, mode = { 'i', 'n', 't' } },
	{ '<a-L>', Nihil.pane_nav 'l', desc = 'Go to Right Window', expr = true, mode = { 'i', 'n', 't' } },
}

map { --- FILE
	{ '<c-s>', '<cmd>write<cr>', mode = { 'i', 'n', 'x', 's' }, desc = 'Save File' },
	{ '<leader>fn', '<cmd>enew<cr>', desc = 'New File' },
	{ '<leader>fd', function() Nihil.file.delete() end, desc = 'Delete File' },
	{ '<leader>fx', ':write | !chmod +x %<cr><cmd>e! % <cr>', desc = 'Set File Executable' },
}

map { --- TERMINAL
	{ '<a-~>', '<cmd>term <cr>', desc = 'New Terminal' },
	{ '<c-s-space>', '<c-\\><c-n>', mode = 't', desc = 'Escape Terminal' },
	{ '<c-;>', '<a-|>', mode = 't', desc = 'Sendkey alt-|' },
	-- { '<c-tab>', '<c-tab>', mode = 't', desc = 'Sendkey ctrl-tab' },
	-- { '<c-s-tab>', '<c-s-tab>', mode = 't', desc = 'Sendkey ctrl-shift-tab' },

	{ -- Mimic CTRL-R in terminal to paste from a register
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
	},
}

map { --- LSP & DIAGNOSTICS
	{ '<a-F>', function() LazyVim.format.format { force = true } end, mode = { 'n', 'v', 'i' }, desc = 'Format Buffer' },
	{ ']d', Nihil.diag_jump(1), desc = 'Next Diagnostic' },
	{ '[d', Nihil.diag_jump(-1), desc = 'Prev Diagnostic' },
	{ ']w', Nihil.diag_jump(1, 'WARN'), desc = 'Next Warning Diagnostic' },
	{ '[w', Nihil.diag_jump(-1, 'WARN'), desc = 'Prev Warning Diagnostic' },
	{ ']e', Nihil.diag_jump(1, 'ERROR'), desc = 'Next Error Diagnostic' },
	{ '[e', Nihil.diag_jump(-1, 'ERROR'), desc = 'Prev Error Diagnostic' },
}

map { --- UI
	{ '<leader>ui', vim.show_pos, desc = 'Inspect highlight under cursor' },
	{ '<leader>um', '<cmd>delm! | delm A-Z0-9 | redraw <cr>', desc = 'Clear Marks' },

	-- Clear visual noise
	{ '<leader>uc', Nihil.clear_ui_noises, desc = 'Clear Visual Noises', nowait = true, mode = { 'n', 'x' } },
	{ '<c-l>', Nihil.clear_ui_noises, desc = 'Clear Visual Noises', nowait = true, mode = { 'n', 'x' } },
}

map { --- SYSTEM
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
	{ '<f2>L', function() LazyVim.news.changelog() end, desc = 'LazyVim Changelog', icon = '' },
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
					height = 1,
					width = 1,
					keys = { ['<c-q>'] = { 'close', expr = true, mode = 't' } },
				},
			})
		end,
		desc = 'BTOP',
		icon = '',
	},
}

--- TOGGLES
if type(LazyVim) ~= 'nil' and type(Snacks) ~= 'nil' then
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
end
