---@type table<number, LazyPluginSpec>
return {
	{ -- Rose Pine
		'rose-pine/neovim',
		name = 'rose-pine',
		cond = true,
		lazy = false,
		priority = 1000,

		---@type Options
		opts = {
			variant = 'auto', -- auto, main, moon, or dawn
			dark_variant = 'main', -- main, moon, or dawn
			dim_inactive_windows = false,
			extend_background_behind_borders = true,

			enable = { terminal = true, migrations = true },

			styles = {
				bold = true,
				italic = true,
				transparency = true,
			},

			---@type table<string, vim.api.keyset.highlight>
			highlight_groups = {
				IndentChar = { fg = 'highlight_low' },
				IndentCharActive = { fg = 'highlight_high' },
				ColorColumn = { bg = 'base' },
				CursorLineNr = { fg = 'foam', bold = true, italic = true },
				FloatBorder = { fg = 'overlay' },

				Comment = { fg = 'muted' },
				Folded = { bg = 'base' },
				VertSplit = { fg = 'overlay', bg = 'muted' },
				Search = { bg = 'highlight_med', fg = 'none' },
				IncSearch = { bg = 'gold', fg = 'black' },
				CurSearch = { bg = 'highlight_low', fg = 'none', underline = true },
				Visual = { bg = 'subtle' },
				Normal = { bg = 'none' },
				NormalFloat = { bg = 'none' },
				PmenuSel = { bg = 'highlight_low', fg = 'none' },
				Pmenu = { fg = 'highlight_med' },

				LspReferenceText = { bg = 'highlight_low', fg = 'none' },
				LspReferenceRead = { bg = 'highlight_low', fg = 'none' },
				LspReferenceWrite = { bg = 'highlight_low', fg = 'none' },

				TroubleNormal = { bg = 'none' },
				-- VirtColumn = { fg = 'base' },
				IlluminatedWordText = { bg = 'highlight_low' },
				IlluminatedWordRead = { bg = 'highlight_low' },
				IlluminatedWordWrite = { bg = 'highlight_low' },
				NeoTreeCursorLine = { bg = 'base', bold = true },

				WhichKeyBorder = { fg = 'highlight_med' },
				LazyGitBorder = { fg = 'highlight_med' },
			},
		},
	},

	{ -- Catppuccin
		'catppuccin/nvim',
		name = 'catppuccin',
		cond = false,
		lazy = false,
		priority = 1000,
		opts = {
			flavour = 'mocha', -- latte, frappe, macchiato, mocha
			transparent_background = true,
			term_colors = true,
			styles = {
				comments = { 'italic' },
				conditionals = { 'italic' },
				types = { 'bold' },
			},
		},
	},
}
