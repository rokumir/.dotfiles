---@module 'lazy'
---@module 'snacks'

---@type LazyPluginSpec[]
return {
	{
		'folke/snacks.nvim',
		keys = function()
			return {
				-- scratch
				{ '<leader>.', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer' },
				{ '<leader>S', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer' },
				{ '<leader>dps', function() Snacks.profiler.scratch() end, desc = 'Profiler Scratch Buffer' },

				{ '<f2>h', function() Snacks.health.check() end, desc = 'Check Health' },
			}
		end,

		---@type snacks.Config
		opts = {
			scroll = { enabled = false },
			input = { enabled = true },
			scope = { enabled = true },

			quickfile = {
				exclude = { 'latex', 'typescript', 'typescriptreact' },
			},
			bigfile = {
				enabled = true,
				notify = true, -- show notification when big file detected
				size = 1.5 * (1024 * 1024), -- 1.5MB
				-- -- Enable or disable features when big file detected
				-- ---@param ctx {buf: number, ft:string}
				-- setup = function(ctx)
				-- 	if vim.fn.exists ':NoMatchParen' ~= 0 then vim.cmd [[NoMatchParen]] end
				-- 	Snacks.util.wo(0, { foldmethod = 'manual', statuscolumn = '', conceallevel = 0 })
				-- 	vim.b.minianimate_disable = true
				-- 	vim.schedule(function()
				-- 		if vim.api.nvim_buf_is_valid(ctx.buf) then vim.bo[ctx.buf].syntax = ctx.ft end
				-- 	end)
				-- end,
			},

			scratch = {
				win = {
					max_height = 25,
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
						horizontal = '',
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
	},
	{ import = 'plugins.snacks' },
	{ import = 'plugins.snacks.pickers' },
}
