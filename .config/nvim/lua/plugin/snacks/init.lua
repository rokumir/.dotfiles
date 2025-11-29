---@module 'lazy'
---@module 'snacks'

---@type LazyPluginSpec[]
return {
	{
		'folke/snacks.nvim',
		priority = 10000,
		keys = function() return {} end,

		---@type snacks.Config
		opts = {
			scroll = { enabled = false },
			input = { enabled = true },
			scope = { enabled = true },
			words = { enabled = true },

			statuscolumn = {
				enabled = true,
				refresh = 50, --ms
			},

			image = {
				enabled = true,
				preferred_protocol = 'wezterm', -- or "kitty"
				fallback_protocol = 'chafa',
				inline_in_docs = true,
				max_width = 80,
				max_height = 40,
			},

			-- quickfile = { exclude = { 'latex', 'lua' }, },
			bigfile = {
				enabled = true,
				notify = true, -- show notification when big file detected
				size = 2 * (1024 * 1024), -- Mb
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
						horizontal = '',
						vertical = '│',
						arrow = '',
					},
				},
			},

			---@type snacks.notifier.Config|{}
			notifier = {
				---@type snacks.notifier.style
				style = 'minimal',
				top_down = false,
			},

			zen = {
				-- You can add any `Snacks.toggle` id/key here.
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
					statusline = true,
					tabline = true,
				},
				win = {
					backdrop = 25,
				},
			},

			explorer = { replace_netrw = false },
		},
	},
	{ import = 'plugin.snacks' },
	{ import = 'plugin.snacks.pickers' },
}
