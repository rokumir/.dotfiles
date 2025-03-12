---@module 'lazy'
---@type table<number, LazyPluginSpec>
return {
	{ -- Typescript type debug
		'marilari88/twoslash-queries.nvim',
		ft = { 'typescript', 'typescriptreact', 'astro' },
		opts = {
			multi_line = true,
			is_enabled = true,
			highlight = 'Comment',
		},
	},

	{ -- Lua Type: Wezterm object
		'justinsgithub/wezterm-types',
		lazy = true,
		dependencies = { 'lazydev.nvim', opts = function(_, opts) table.insert(opts.library, { path = 'wezterm-types', mods = { 'wezterm' } }) end },
		cond = function() return vim.fn.fnamemodify(vim.fn.expand '%', ':t') == 'wezterm.lua' end,
	},

	-- NOTE: DEPRECATED in favor of custom made plugin
	-- Convert color likes hex to smth else
	{
		'cjodo/convert.nvim',
		enabled = false,
		cond = false,
		dependencies = 'MunifTanjim/nui.nvim',
		ft = { 'lua', 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'json', 'yaml', 'html', 'css', 'scss', 'less', 'markdown' },
		keys = {
			{ '<a-c><a-n>', '<cmd>ConvertFindNext <cr>', desc = 'Color Convertor: Find next' },
			{ '<a-c><a-c>', '<cmd>ConvertFindCurrent <cr>', desc = 'Color Convertor: Find current line' },
			{ '<a-c><a-a>', '<cmd>ConvertAll <cr>', desc = 'Color Convertor: Convert all' },
		},
		opts = {
			keymaps = {
				focus_next = { 'j', '<down>' },
				focus_prev = { 'k', '<up>' },
				close = { '<esc>', '<c-c>', '<c-q>' },
				submit = { '<cr>', '<space>', 'l' },
			},
		},
	},
	-- NOTE: DEPRECATED in favor of custom made plugin
	{ -- General Color highlight & picker (with oklch)
		'eero-lehtinen/oklch-color-picker.nvim',
		event = 'VeryLazy',
		lazy = false,
		enabled = false,
		opts = {
			highlight = {
				enabled = true,
				edit_delay = 60,
				scroll_delay = 0,
			},
			patterns = {
				css_oklch = { priority = -1, '()oklch%([^,]-%)()' },
				hex_literal = { priority = -1, '()0x%x%x%x%x%x%x+%f[%W]()' },
				tailwind = {
					priority = -2,
					custom_parse = function(str) return require('oklch-color-picker.tailwind').custom_parse(str) end,
					'%f[%w][%l%-]-%-()%l-%-%d%d%d?%f[%W]()',
				},
				hex = false,
				css_rgb = false,
				css_hsl = false,
				numbers_in_brackets = false,
			},
			auto_download = false,
			register_cmds = false,
		},
	},
	-- NOTE: DEPRECATED in favor of custom made plugin
	{ -- highlight hex colors
		'brenoprata10/nvim-highlight-colors',
		event = 'VeryLazy',
		lazy = false,
		keys = {
			{ '<leader>uh', ':HighlightColors Toggle<cr>', desc = 'Toggle color highlight (HEX, RGB, etc.)' },
		},
		opts = {
			render = 'virtual', --- background | foreground | virtual
			virtual_symbol = '', -- requires `vitual` mode
			virtual_symbol_prefix = '',
			virtual_symbol_suffix = ' ',
			virtual_symbol_position = 'inline',

			enable_hex = true, ---Highlight hex colors, e.g. '#FFFFFF'
			enable_short_hex = false, ---Highlight short hex colors e.g. '#fff'
			enable_rgb = true, ---Highlight rgb colors, e.g. 'rgb(0 0 0)'
			enable_hsl = true, ---Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
			enable_var_usage = true, ---Highlight CSS variables, e.g. 'var(--testing-color)'
			enable_named_colors = false, ---Highlight named colors, e.g. 'green'
			enable_tailwind = true, ---Highlight tailwind colors, e.g. 'bg-blue-500'
			exclude_filetypes = { 'text', 'lazy', 'help' },
		},
	},

	{ 'nihil/virt-column', priority = 1000 },
}
