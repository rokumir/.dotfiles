---@diagnostic disable: no-unknown

local function is_note_root_dir()
	local note_dir = vim.uv.fs_realpath(vim.env.MY_NOTE_HOME)
	if note_dir then return vim.uv.cwd() == note_dir end
	return false
end

---@module 'lazy'
---@type LazyPluginSpec[]
return {
	{
		'obsidian-nvim/obsidian.nvim',
		version = '*',
		lazy = true,

		cond = is_note_root_dir,
		ft = 'markdown',

		keys = {
			{ '<a-o>', '<cmd>ObsidianOpen<cr>', mode = { 'i', 'n' } },
			{ '<a-t>', '<cmd>ObsidianTags<cr>', mode = { 'i', 'n' } },
			{
				'gf',
				function() return require('obsidian.util').cursor_on_markdown_link() and '<cmd>ObsidianFollowLink<CR>' or 'gf' end,
				noremap = false,
				expr = true,
				buffer = true,
			},
			{ '<a-l>', '<cmd>ObsidianToggleCheckbox<cr>', buffer = true, expr = true },
		},

		opts = {
			workspaces = {
				{ name = 'note', path = vim.uv.fs_realpath(vim.env.MY_NOTE_HOME) },
			},
			open_app_foreground = true,
			disable_frontmatter = true,

			completion = { nvim_cmp = false },

			ui = { enable = false },
		},
	},
}
