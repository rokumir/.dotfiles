---@diagnostic disable: missing-fields
local note_path = vim.uv.fs_realpath(vim.env.RH_NOTE) or ''
local keymap = require('utils.keymap').map

---@module 'lazy'
---@type LazyPluginSpec[]
return {
	{
		'obsidian-nvim/obsidian.nvim',

		-- cond = is_note_root_dir,
		ft = 'markdown',
		event = {
			'BufReadPre ' .. note_path .. '/*.md',
			'BufNewFile ' .. note_path .. '/*.md',
		},

		---@module 'obsidian'
		---@type obsidian.config.ClientOpts|{}
		opts = {
			disable_frontmatter = true,
			ui = { enable = false },
			completion = { blink = true },
			workspaces = {
				{ name = 'notes', path = note_path },
			},
			open = {
				func = function(uri) vim.ui.open(uri, { cmd = { 'xdg-open' } }) end,
			},
		},

		config = function(_, opts)
			require('obsidian').setup(opts)

			keymap { '<a-o>', '<cmd>ObsidianOpen<cr>', mode = { 'i', 'n' } }
			keymap { ';sT', '<cmd>ObsidianTags<cr>', mode = { 'i', 'n' } }
			keymap {
				'gd',
				function() return require('obsidian.util').cursor_on_markdown_link() and '<cmd>ObsidianFollowLink<CR>' or 'gd' end,
				desc = 'Follow Link',
				noremap = false,
				expr = true,
				buffer = true,
			}
			keymap { '<a-l>', '<cmd>ObsidianToggleCheckbox<cr>' }
		end,
	},
}
