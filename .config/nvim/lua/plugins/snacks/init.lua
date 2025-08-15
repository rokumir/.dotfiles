---@module 'lazy'
---@module 'snacks'

---@type LazyPluginSpec
local snacks_config = {
	'folke/snacks.nvim',
	keys = {
		{ ';;', function() Snacks.picker.resume() end, desc = 'Resume' },
		{ ';S', function() Snacks.picker() end, desc = 'Search Pickers' },

		-- Top Pickers & Explorer
		{ '<c-e>', function() Snacks.picker.files() end, desc = 'Find Files' },
		{ ';r', function() Snacks.picker.recent { filter = { cwd = true } } end, desc = 'Recent' },
		{ ';b', function() Snacks.picker.buffers() end, desc = 'Buffers' },
		{ ';/', function() Snacks.picker.grep() end, desc = 'Grep' },
		{ ';:', function() Snacks.picker.command_history() end, desc = 'Command History' },
		{ ';n', function() Snacks.picker.notifications() end, desc = 'Notification History' },
		{ 'zx', function() Snacks.explorer() end, desc = 'File Explorer' },
		{ 'zX', function() Snacks.explorer.open { focus = false } end, desc = 'File Explorer' },

		-- Find
		{ ';f', '', desc = 'find' },
		{ ';ff', function() Snacks.picker.files() end, desc = 'Find Files' },
		{ ';fg', function() Snacks.picker.git_files() end, desc = 'Find Git Files' },
		{ ';fc', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Find Config File' },
		{ ';D', function() Snacks.picker.projects() end, desc = 'Projects' },
		{ ';d', function() Snacks.picker.projects { patterns = { '*' } } end, desc = 'Vaults' },

		-- Git
		{ ';g', '', desc = 'git' },
		{ ';gb', function() Snacks.picker.git_branches() end, desc = 'Git Branches' },
		{ ';gl', function() Snacks.picker.git_log() end, desc = 'Git Log' },
		{ ';gL', function() Snacks.picker.git_log_line() end, desc = 'Git Log Line' },
		{ ';gs', function() Snacks.picker.git_status() end, desc = 'Git Status' },
		{ ';gS', function() Snacks.picker.git_stash() end, desc = 'Git Stash' },
		{ ';gd', function() Snacks.picker.git_diff() end, desc = 'Git Diff (Hunks)' },
		{ ';gf', function() Snacks.picker.git_log_file() end, desc = 'Git Log File' },

		-- Search
		{ ';s', '', desc = 'search' },
		-- grep
		{ '<a-/>', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
		{ ';sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
		-- { ';sg', function() Snacks.picker.grep() end, desc = 'Grep' },
		{ ';sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers' },
		{ ';sw', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' } },
		-- others
		{ ';s"', function() Snacks.picker.registers() end, desc = 'Registers' },
		{ ';s/', function() Snacks.picker.search_history() end, desc = 'Search History' },
		{ ';sa', function() Snacks.picker.autocmds() end, desc = 'Autocmds' },
		-- { ';sc', function() Snacks.picker.command_history() end, desc = 'Command History' },
		{ ';sc', function() Snacks.picker.commands() end, desc = 'Commands' },
		{ ';sd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' },
		{ ';sD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics' },
		{ ';sh', function() Snacks.picker.help() end, desc = 'Help Pages' },
		{ ';sH', function() Snacks.picker.highlights() end, desc = 'Highlights' },
		{ ';si', function() Snacks.picker.icons() end, desc = 'Icons' },
		{ ';sj', function() Snacks.picker.jumps() end, desc = 'Jumps' },
		{ ';sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
		{ ';sl', function() Snacks.picker.loclist() end, desc = 'Location List' },
		{ ';sm', function() Snacks.picker.marks() end, desc = 'Marks' },
		{ ';sM', function() Snacks.picker.man() end, desc = 'Man Pages' },
		{ ';sp', function() Snacks.picker.lazy() end, desc = 'Search for Plugin Spec' },
		{ ';sq', function() Snacks.picker.qflist() end, desc = 'Quickfix List' },
		{ ';su', function() Snacks.picker.undo() end, desc = 'Undo History' },
		{ ';st', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },
		-- lsp
		{ ';ss', function() Snacks.picker.lsp_symbols() end, desc = 'LSP Symbols' },
		{ ';sS', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols' },

		-- scratch
		{ '<leader>.', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer' },
		{ '<leader>S', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer' },
		{ '<leader>dps', function() Snacks.profiler.scratch() end, desc = 'Profiler Scratch Buffer' },
	},

	---@type snacks.Config
	opts = {
		bigfile = { enabled = false },
		scroll = { enabled = false },
		dashboard = { enabled = true },
		image = { enabled = true },
		input = { enabled = true },
		scope = { enabled = true },

		scratch = {
			win = {
				keys = {
					q = false,
				},
			},
		},

		indent = {
			priority = 200,
			indent = { enabled = true },
			animate = { enabled = true, style = 'out' },
			scope = { enabled = false },
			chunk = {
				enabled = true,
				char = {
					corner_top = '╭',
					corner_bottom = '╰',
					horizontal = '─',
					vertical = '│',
					arrow = '',
				},
			},
		},

		---@type snacks.notifier.Config|{}
		notifier = {
			---@type snacks.notifier.style
			style = 'compact',
			top_down = false,
		},

		zen = {
			-- You can add any `Snacks.toggle` id here.
			-- Toggle state is restored when the window is closed.
			-- Toggle config options are NOT merged.
			---@type table<string, boolean>
			toggles = {
				dim = true,
				git_signs = false,
				mini_diff_signs = false,
				diagnostics = true,
				inlay_hints = false,
			},
			show = {
				statusline = false,
				tabline = false,
			},
		},

		explorer = {
			replace_netrw = true,
		},
	},
}

return {
	{ 'folke/snacks.nvim', keys = function() return {} end },
	snacks_config,
	{ import = 'plugins.snacks' },
	{ import = 'plugins.snacks.pickers' },
}

-- Overriding snacks types
---@class snacks.picker.Config
---@field exclude? string[]
