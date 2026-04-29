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

			-- quickfile = { exclude = { 'latex', 'lua' }, },
			bigfile = {
				enabled = true,
				notify = true, -- show notification when big file detected
				line_length = 1000,
				size = 800 * 1024, -- Kb
				---@param ctx {buf: number, ft:string}
				setup = function(ctx)
					_G.nihil = 'foooooooo'
					if vim.fn.exists ':NoMatchParen' ~= 0 then vim.cmd [[NoMatchParen]] end
					Snacks.util.wo(0, { foldmethod = 'manual', statuscolumn = '', conceallevel = 0 })
					vim.b.completion = false
					vim.b.minianimate_disable = true
					vim.b.minihipatterns_disable = true
					vim.schedule(function()
						if vim.api.nvim_buf_is_valid(ctx.buf) then vim.bo[ctx.buf].syntax = ctx.ft end
					end)
				end,
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
				enabled = false,
				---@type snacks.notifier.style
				style = 'minimal',
				top_down = false,
			},

			zen = { enabled = false },

			explorer = { replace_netrw = false },
		},
	},
	{ import = 'plugin.snacks' },
	{ import = 'plugin.snacks.pickers' },
}
