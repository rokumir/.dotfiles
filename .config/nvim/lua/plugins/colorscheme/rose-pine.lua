---@diagnostic disable: assign-type-mismatch
return {
	{
		'rose-pine/neovim',
		name = 'rose-pine',
		priority = 3000,
		opts = {
			variant = 'main',
			dark_variant = 'dawn',
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

			---@type table<string, vim.api.keyset.set_hl_info>
			highlight_groups = {
				--#region builtins
				ColorColumn = { bg = 'base' },
				CursorLineNr = { fg = 'foam', bold = true, italic = true },
				FloatBorder = { fg = 'overlay' },
				WinSeparator = { fg = 'overlay' },
				Tabline = { bg = 'none' },
				TabLineFill = { bg = 'none' },
				TabLineSel = { bg = 'none' },
				WinBar = { fg = 'subtle' },
				WinBarNC = { fg = 'muted' },
				StatusLineTerm = { bg = 'pine', blend = 10 },
				StatusLineTermNC = { bg = 'pine', blend = 5 },

				PmenuThumb = { bg = 'subtle', blend = 20 },
				PmenuSel = { bg = 'muted', fg = 'none', blend = 15 },
				Conceal = { bg = 'base', blend = 15, force = true },
				MsgArea = { fg = 'subtle' },
				Comment = { fg = 'muted' },
				Folded = { fg = 'pine', bg = 'highlight_med', blend = 20 },
				VertSplit = { fg = 'overlay', bg = 'muted' },
				Search = { bg = 'highlight_med', fg = 'none' },
				IncSearch = { bg = 'gold', fg = 'black' },
				CurSearch = { bg = 'highlight_low', fg = 'none', underline = true },
				Visual = { bg = 'subtle' },
				--#endregion

				--#region misc
				TreesitterContext = { bg = 'surface' },
				TreesitterContextLineNumber = { bg = 'surface' },
				TreesitterContextBottom = { bg = 'surface' },
				TreesitterContextLineNumberBottom = { bg = 'surface' },
				EdgyWinBar = { bg = 'surface' },
				DropBarMenuHoverEntry = { bg = 'overlay' },
				YankyPut = { bg = 'pine', blend = 25 },
				YankyYanked = { bg = 'love', blend = 25 },
				UfoFoldVirtText = { fg = 'pine', bold = true },
				UfoFoldVirtFillerText = { fg = 'pine', bold = true },
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

				SnacksBackdrop = { bg = 'none', blend = 0 },
				SnacksIndent = { fg = 'overlay' },
				SnacksIndentScope = { fg = 'highlight_med' },
				SnacksIndentChunk = { fg = 'highlight_med' },
				SnacksInputNormal = { bg = 'none' },

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
			},
		},
	},
	-- {
	-- 	'rose-pine',
	-- 	---@param opts {[string]: any, highlight_groups: table<string, vim.api.keyset.set_hl_info>}
	-- 	opts = function(_, opts)
	-- 		opts.palette.moon = opts.palette.main
	--
	-- 		if pcall(require, 'oil') then
	-- 			for status, link in pairs {
	-- 				Added = '@keyword',
	-- 				Copied = 'DiagnosticInfo',
	-- 				Deleted = 'GitSignsDelete',
	-- 				Ignored = 'DiagnosticOk',
	-- 				Renamed = 'GitSignsChange',
	-- 				Modified = 'GitSignsChange',
	-- 				Unmerged = 'DiagnosticError',
	-- 				Untracked = 'DiagnosticOk',
	-- 				Unmodified = '@text',
	-- 				TypeChanged = 'GitSignsChange',
	-- 			} do
	-- 				local hl_index = 'OilGitStatusIndex' .. status
	-- 				local hl_work = 'OilGitStatusWorkingTree' .. status
	-- 				local hl_short = 'OilGit' .. status
	-- 				opts.highlight_groups[hl_index] = { link = link }
	-- 				opts.highlight_groups[hl_work] = { link = hl_index }
	-- 				opts.highlight_groups[hl_short] = { link = hl_index }
	-- 			end
	-- 		end
	-- 	end,
	-- },
}
