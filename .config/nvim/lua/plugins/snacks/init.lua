---@module 'lazy'
---@module 'snacks'

---@type LazyPluginSpec[]
return {
	{
		'folke/snacks.nvim',
		keys = function() return {} end,

		---@type snacks.Config
		opts = {
			scroll = { enabled = false },
			input = { enabled = true },
			scope = { enabled = true },

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
					statusline = true,
					tabline = true,
				},
				---@type snacks.win.Config
				win = {
					backdrop = 25,
				},
			},

			explorer = { replace_netrw = false },
		},
	},
	{ import = 'plugins.snacks' },
	{ import = 'plugins.snacks.pickers' },
}
