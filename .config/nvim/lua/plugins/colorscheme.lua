---@module 'lazy'
---@type LazyPluginSpec[]
return {
	{ -- Rose Pine
		'rose-pine/neovim',
		name = 'rose-pine',
		priority = 1000,
		opts = {
			variant = 'auto', -- auto, main, moon, or dawn
			dark_variant = 'main', -- main, moon, or dawn
			dim_inactive_windows = false,
			extend_background_behind_borders = true,
			enable = { terminal = true, migrations = true },
			styles = { transparency = false, bold = true, italic = true },
			palette = {
				main = {
					base = '#0f0f0f',
					surface = '#0c0c0c',
					overlay = '#1f1f1f',
					muted = '#687077',
					subtle = '#88929c',
					text = '#d9e2eb',
					love = '#f66390',
					gold = '#f1c383',
					rose = '#f1b9b7',
					pine = '#209081',
					foam = '#88ccd8',
					iris = '#b1aef0',
					highlight_low = '#252727',
					highlight_med = '#45484c',
					highlight_high = '#565b60',
				},
			},
			---@type table<string, vim.api.keyset.highlight>
			highlight_groups = {
				ColorColumn = { bg = 'base' },
				CursorLineNr = { fg = 'foam', bold = true, italic = true },
				FloatBorder = { fg = 'surface', bg = 'surface' },
				WinSeparator = { fg = 'overlay' },

				MsgArea = { fg = 'subtle' },
				Comment = { fg = 'muted' },
				Folded = { bg = 'base' },
				VertSplit = { fg = 'overlay', bg = 'muted' },
				Search = { bg = 'highlight_med', fg = 'none' },
				IncSearch = { bg = 'gold', fg = 'black' },
				CurSearch = { bg = 'highlight_low', fg = 'none', underline = true },
				Visual = { bg = 'subtle' },
				PmenuThumb = { bg = 'subtle', blend = 20 },
				PmenuSel = { bg = 'muted', fg = 'none', blend = 15 },

				LspReferenceText = { bg = 'highlight_low', fg = 'none' },
				LspReferenceRead = { bg = 'highlight_low', fg = 'none' },
				LspReferenceWrite = { bg = 'highlight_low', fg = 'none' },

				TroubleNormal = { bg = 'none' },
				IlluminatedWordText = { bg = 'highlight_low' },
				IlluminatedWordRead = { bg = 'highlight_low' },
				IlluminatedWordWrite = { bg = 'highlight_low' },
				NeoTreeCursorLine = { bg = 'base', bold = true },

				WhichKeyBorder = { link = 'FloatBorder' },
				LazyGitBorder = { link = 'FloatBorder' },
				-- LazyBackdrop = { bg = 'love' },

				SnacksIndent = { fg = 'highlight_low' },
				SnacksIndentScope = { fg = 'highlight_high' },
				SnacksIndentChunk = { fg = 'highlight_high' },

				BlinkCmpMenuBorder = { fg = 'overlay' },
				BlinkCmpDoc = { bg = 'surface' },
				BlinkCmpDocBorder = { fg = 'overlay' },
				BlinkCmpDocSeparator = { bg = 'surface', fg = 'overlay' },

				YankyPut = { bg = 'pine', blend = 25 },
				YankyYanked = { bg = 'love', blend = 25 },
			},
		},
	},

	{ -- Catppuccin
		'catppuccin/nvim',
		name = 'catppuccin',
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
