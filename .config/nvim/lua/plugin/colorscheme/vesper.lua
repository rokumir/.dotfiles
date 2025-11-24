-- NOTE: Blend in this theme makes neovide transparent
return {
	'datsfilipe/vesper.nvim',
	name = 'vesper',
	lazy = true,
	priority = 4000,
	config = function()
		---@class VesperPalette Palette overrides
		local cp = {}
		local util = require 'vesper.utils'
		local mix = util.mix
		local blend = function(color, value) return util.shade(color, value, cp.bg or '#000000') end

		-- background colors
		cp.white = '#E8ECF0'
		cp.black = '#050505'
		cp.bg = '#080808'
		cp.bgDark = '#0c0c0c'
		cp.bgDarker = '#1F1F1F'
		cp.bgFloat = cp.bgDark
		cp.bgOption = cp.bgDarker

		cp.fg = '#D9E2EB'
		cp.fgAlt = blend(cp.fg, 0.82)
		cp.fgCommand = blend(cp.fg, 0.9)
		cp.fgInactive = blend(cp.fg, 0.6)
		cp.fgDisabled = mix(cp.fg, '#4b515a', 0.6)
		cp.fgLineNr = '#505050'
		cp.fgSelection = '#343434'
		cp.fgSelectionInactive = '#505050'

		cp.border = mix(cp.bgDark, cp.white, 0.7)
		cp.borderFocus = cp.border
		cp.borderDarker = blend(cp.border, 0.5)

		-- ui colors
		cp.primary = '#8f959e'
		cp.secondary = '#FFFFFF'
		cp.comment = blend(cp.fg, 0.4)
		cp.symbol = blend(cp.primary, 0.8)
		cp.terminalbrightblack = '#343434'

		cp.green = '#77c8ac'
		cp.greenLight = blend(cp.green, 0.9)
		cp.orange = '#EFC9A5'
		cp.orangeLight = mix(cp.orange, cp.white, 0.94)
		cp.purple = cp.orange
		cp.purpleDark = blend(cp.purple, 0.92)
		cp.red = '#FD7CA0'
		cp.redDark = mix(cp.red, '#f38e54', 0.9)
		cp.yellowDark = '#FFC799'
		cp.blue = '#45c6d2'
		cp.blueLight = '#76b1bb'

		-- diagnostic colors
		cp.error = cp.redDark
		cp.warn = '#FFC799'
		cp.info = mix(cp.green, '#7DDEDA', 0.94)
		cp.hint = '#A5A1EA'

		require('vesper').setup {
			transparent = false,
			italics = {
				comments = true,
				keywords = true,
				functions = true,
				strings = true,
				variables = true,
			},
			palette_overrides = cp,
			---@type table<string, vim.api.keyset.set_hl_info>
			overrides = {
				--#region builtins
				ColorColumn = { bg = cp.bg },
				CursorLineNr = { fg = cp.greenLight, bold = true, italic = true },
				FloatBorder = { fg = cp.borderDarker, bg = 'none' },
				WinSeparator = { fg = cp.borderDarker },
				Tabline = { bg = 'none' },
				TabLineFill = { bg = 'none' },
				TabLineSel = { bg = 'none' },
				StatusLineTerm = { bg = 'none' },
				StatusLineTermNC = { bg = 'none' },

				PmenuThumb = { bg = cp.fgInactive },
				PmenuSel = { bg = cp.bgOption, fg = 'none' },
				-- PmenuKind = vim.empty_dict(),

				Conceal = { blend = 15, force = true, link = 'NonText' },
				MsgArea = { fg = cp.fgAlt },
				Folded = { fg = cp.green, bg = mix(cp.bgDark, cp.white, 0.96) },
				VertSplit = { fg = cp.borderDarker },
				Search = { bg = blend(cp.redDark, 0.35) },
				IncSearch = { bg = blend(cp.green, 0.35) },
				CurSearch = { link = 'IncSearch' },
				Visual = { bg = blend(cp.bgDarker, 0.9) },
				Terminal = { bg = cp.bgDark },
				MutedText = { fg = cp.fgInactive },
				NonText = { fg = blend(cp.fg, 0.4) },
				Special = { fg = blend(cp.fg, 0.8) },
				Directory = { fg = mix(cp.green, cp.fg, 0.8), bold = true },

				DiagnosticOk = { ctermfg = 2, fg = cp.greenLight },
				DiagnosticUnderlineError = { sp = cp.error, undercurl = true },
				DiagnosticUnderlineHint = { sp = cp.hint, undercurl = true },
				DiagnosticUnderlineInfo = { sp = cp.info, undercurl = true },
				DiagnosticUnderlineWarn = { sp = cp.warn, undercurl = true },
				DiagnosticUnderlineOk = { sp = mix(cp.green, '#5f7370', 0.7), undercurl = true },

				DiffAdd = { bg = cp.bg, fg = blend(cp.green, 0.7) },
				DiffChange = { bg = cp.bg, fg = blend(cp.orange, 0.7) },
				DiffDelete = { bg = cp.bg, fg = blend(cp.red, 0.7) },
				DiffText = { bg = cp.bg, fg = blend(cp.symbol, 0.7) },
				--#endregion

				--#region misc
				TreesitterContext = { bg = cp.bg },
				TreesitterContextLineNumber = { bg = cp.bg },
				TreesitterContextBottom = { bg = cp.bg },
				TreesitterContextSeparator = { fg = cp.bgDarker },
				EdgyWinBar = { bg = cp.bgDark },
				DropBarMenuHoverEntry = { bg = cp.bgDark },
				YankyPut = { bg = blend(cp.green, 0.25) },
				YankyYanked = { bg = blend(cp.redDark, 0.25) },
				UfoFoldVirtText = { fg = cp.green, italic = true },
				UfoFoldVirtFillerText = { fg = blend(cp.green, 0.6) },
				MiniMapNormal = vim.empty_dict(),
				MiniMapSymbolLine = { fg = cp.green },
				MiniMapSymbolView = { bg = cp.fgDisabled },
				InclineNormal = { bg = 'none', fg = mix(cp.comment, cp.white, 0.8) },
				InclineNormalNC = { link = 'InclineNormal' },
				MiniIconsAzure = { fg = cp.blueLight },
				--#endregion

				--#region lsp
				LspReferenceText = { bg = cp.bgDarker, fg = 'none' },
				LspReferenceRead = { bg = cp.bgDarker, fg = 'none' },
				LspReferenceWrite = { bg = cp.bgDarker, fg = 'none' },
				--#endregion

				--#region Lazy stuffs (Noice, WhichKey)
				TroubleNormal = { bg = 'none' },

				LazyGitBorder = { link = 'FloatBorder' },
				LazyBackdrop = { bg = cp.bg },
				LazyCommit = { fg = cp.redDark },
				LazyButton = { fg = cp.fgAlt, bg = cp.bgDarker },
				LazySpecial = { fg = cp.greenLight },
				LazyH1 = { fg = cp.black, bg = cp.green },
				--#endregion

				--#region Snacks.nvim
				SnacksTitle = { fg = cp.green, bg = cp.bgDark },

				SnacksIndent = { fg = cp.bgDarker },
				SnacksIndentScope = { fg = cp.bgDarker },
				SnacksIndentChunk = { fg = cp.bgDarker },

				SnacksPicker = { bg = cp.bgDark },
				SnacksPickerTree = { fg = cp.bgDarker },
				SnacksPickerBorder = { fg = cp.bgDarker, bg = cp.bgDark },
				SnacksPickerListCursorLine = { bg = cp.bgDarker },
				SnacksPickerMatch = { fg = cp.redDark, underline = true },
				SnacksPickerIcon = { fg = cp.greenLight },

				SnacksDashboardIcon = { link = 'SnacksDashboardTitle', bold = true },
				SnacksDashboardDesc = { link = 'SnacksDashboardTitle' },
				SnacksDashboardDir = { link = 'NonText' },
				SnacksDashboardFile = { link = 'Special', bold = true },

				SnacksPickerLspEnabled = { link = 'DiagnosticInfo' },
				--#endregion

				--#region blink/cmp
				BlinkCmpMenuBorder = { link = 'FloatBorder' },
				BlinkCmpDoc = { bg = cp.bgDark },
				BlinkCmpDocBorder = { link = 'FloatBorder' },
				BlinkCmpDocSeparator = { bg = cp.bgDark, fg = cp.borderDarker },
				BlinkCmpLabel = { fg = cp.fgInactive },

				BlinkCmpMenu = { fg = cp.fgInactive, link = 'Pmenu' },
				--#endregion

				--#region render markdown
				RenderMarkdownCheckboxTodo = { fg = cp.fgInactive },
				RenderMarkdownCheckboxDone = { fg = cp.green },
				RenderMarkdownCheckboxInProgress = { fg = cp.yellowDark },
				RenderMarkdownCheckboxCanceled = { fg = cp.fgDisabled, strikethrough = true, italic = true },
				RenderMarkdownCode = { bg = cp.bgDark },
				RenderMarkdownDash = { fg = cp.bgDarker },
				RenderMarkdownCodeInline = { fg = cp.red, bg = blend(cp.red, 0.1) },
				['@markup.quote.markdown'] = { fg = cp.fgAlt },
				['@markup.raw.block.markdown'] = { fg = cp.fgAlt },
				['@punctuation.special.markdown'] = { fg = cp.fgAlt },
				['@markup.raw.markdown_inline'] = { link = 'RenderMarkdownCodeInline' },
				['@markup.link.label'] = { fg = cp.greenLight, underdashed = true },
				--#endregion

				--#region which-key
				WhichKey = { fg = cp.purple },
				WhichKeyBorder = { link = 'FloatBorder' },
				WhichKeyDesc = { fg = cp.fgCommand },
				WhichKeyFloat = { link = 'NormalFloat' },
				WhichKeyGroup = { fg = cp.greenLight },
				WhichKeyIcon = { fg = cp.green },
				WhichKeyIconAzure = { fg = cp.green },
				WhichKeyIconBlue = { fg = cp.green },
				WhichKeyIconCyan = { fg = cp.greenLight },
				WhichKeyIconGreen = { fg = mix(cp.green, cp.white, 0.95) },
				WhichKeyIconGrey = { fg = cp.fgAlt },
				WhichKeyIconOrange = { fg = cp.yellowDark },
				WhichKeyIconPurple = { fg = cp.purple },
				WhichKeyIconRed = { fg = cp.red },
				WhichKeyIconYellow = { fg = cp.orange },
				WhichKeyNormal = { link = 'NormalFloat' },
				WhichKeySeparator = { fg = cp.fgAlt },
				WhichKeyTitle = { link = 'FloatTitle' },
				WhichKeyValue = { fg = cp.yellowDark },
				--#endregion

				--#region Treesitter
				['@symbol'] = { fg = cp.symbol, italic = true },
				Constant = { fg = mix(cp.blue, cp.white, 0.4), italic = true, bold = true },
				--#endregion
			},
		}
	end,
}
