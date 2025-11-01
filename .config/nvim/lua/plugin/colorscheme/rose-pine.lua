return {
	'rose-pine/neovim',
	name = 'rose-pine',
	priority = 4000,
	opts = {
		variant = 'main',
		dark_variant = 'main',
		dim_inactive_windows = false,
		extend_background_behind_borders = true,
		enable = {
			terminal = true,
			migrations = true, -- Handle deprecated options automatically
			legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
		},
		styles = {
			bold = true,
			italic = true,
			transparency = false,
		},

		palette = {
			---@class RosePinePalette
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

		---@type table<string, vim.api.keyset.set_hl_info>
		highlight_groups = {
			--#region builtins
			-- Normal = { bg = 'surface' },
			-- NormalNC = { bg = 'surface' },
			ColorColumn = { bg = 'base' },
			CursorLineNr = { fg = 'foam', bold = true, italic = true },
			FloatBorder = { fg = 'overlay' },
			WinSeparator = { fg = 'overlay' },
			Tabline = { bg = 'none' },
			TabLineFill = { bg = 'none' },
			TabLineSel = { bg = 'none' },
			-- WinBar = { fg = 'subtle' },
			-- WinBarNC = { fg = 'muted' },
			StatusLineTerm = { bg = 'none' },
			StatusLineTermNC = { bg = 'none' },

			PmenuThumb = { bg = 'subtle', blend = 20 },
			PmenuSel = { bg = 'muted', fg = 'none', blend = 15 },
			Conceal = { blend = 15, force = true, link = 'NonText' },
			MsgArea = { fg = 'subtle' },
			Comment = { fg = 'muted' },
			Folded = { fg = 'pine', bg = 'highlight_med', blend = 20 },
			VertSplit = { fg = 'overlay', bg = 'muted' },
			Search = { bg = 'highlight_med', fg = 'none' },
			IncSearch = { bg = 'gold', fg = 'black' },
			CurSearch = { bg = 'highlight_low', fg = 'none', underline = true },
			Visual = { bg = 'subtle' },
			Terminal = { bg = 'surface' },
			--#endregion

			--#region misc
			TreesitterContext = { bg = 'base' },
			TreesitterContextLineNumber = { bg = 'base' },
			TreesitterContextBottom = { bg = 'base' },
			TreesitterContextSeparator = { fg = 'highlight_low' },
			EdgyWinBar = { bg = 'surface' },
			DropBarMenuHoverEntry = { bg = 'overlay' },
			YankyPut = { bg = 'pine', blend = 25 },
			YankyYanked = { bg = 'love', blend = 25 },
			UfoFoldVirtText = { fg = 'pine', bold = true },
			UfoFoldVirtFillerText = { fg = 'pine', bold = true },
			MiniMapNormal = { bg = 'none' },
			MiniMapSymbolLine = { fg = 'pine', blend = 20 },
			MiniMapSymbolView = { bg = 'muted', blend = 20 },
			GitSignsAdd = { fg = 'pine' },
			-- GitSignsChange = { fg = 'rose' },
			-- GitSignsDelete = { fg = 'pine' },
			--#endregion

			--#region lsp
			LspReferenceText = { bg = 'highlight_low', fg = 'none' },
			LspReferenceRead = { bg = 'highlight_low', fg = 'none' },
			LspReferenceWrite = { bg = 'highlight_low', fg = 'none' },
			--#endregion

			--#region Lazy stuffs (Snacks, Noice, WhichKey)
			LazyGitBorder = { link = 'FloatBorder' },
			LazyBackdrop = { bg = 'base', blend = 25 },
			WhichKeyBorder = { link = 'FloatBorder' },
			TroubleNormal = { bg = 'none' },

			-- SnacksNormal = { bg = 'surface' },
			-- SnacksBackdrop = { bg = 'none', blend = 0 },
			SnacksIndent = { fg = 'overlay' },
			SnacksIndentScope = { fg = 'highlight_med' },
			SnacksIndentChunk = { fg = 'highlight_med' },
			SnacksInputNormal = { bg = 'none' },
			SnacksPicker = { bg = 'surface' },
			SnacksPickerTree = { fg = 'highlight_low' },

			NoicePopupBorder = { fg = 'overlay', bg = 'none', blend = 0 },
			NoicePopupmenuBorder = { fg = 'overlay', bg = 'none', blend = 0 },

			IlluminatedWordText = { bg = 'highlight_low' },
			IlluminatedWordRead = { bg = 'highlight_low' },
			IlluminatedWordWrite = { bg = 'highlight_low' },
			--#endregion

			--#region blink
			BlinkCmpMenuBorder = { fg = 'overlay' },
			BlinkCmpDoc = { bg = 'surface' },
			BlinkCmpDocBorder = { fg = 'overlay' },
			BlinkCmpDocSeparator = { bg = 'surface', fg = 'overlay' },
			--#endregion

			--#region render markdown
			RenderMarkdownCheckboxTodo = { fg = 'subtle' },
			RenderMarkdownCheckboxDone = { fg = 'pine' },
			RenderMarkdownCheckboxInProgress = { fg = 'gold' },
			RenderMarkdownCheckboxCanceled = { fg = 'muted', strikethrough = true, italic = true },
			RenderMarkdownCodeInline = { fg = 'rose', bg = 'overlay' },
			RenderMarkdownCode = { bg = 'surface' },
			RenderMarkdownDash = { fg = 'highlight_low' },
			--#endregion
		},
	},
}
