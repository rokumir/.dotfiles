---@diagnostic disable: missing-fields
local ft_util = require 'config.const.filetype'

---@type LazyPluginSpec[]
return {
	{ 'davidmh/mdx.nvim', ft = 'mdx' }, -- treesitter for MDX files

	{ -- Live preview
		'iamcco/markdown-preview.nvim',
		cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
		build = function()
			require('lazy').load { plugins = { 'markdown-preview.nvim' } }
			vim.fn['mkdp#util#install']()
		end,
		ft = ft_util.document_list,
		keys = {
			{ '<leader>uM', '<cmd>MarkdownPreviewToggle<cr>', ft = 'markdown', desc = 'Markdown Preview' },
		},
		config = function() vim.cmd [[do FileType]] end,
	},

	{ -- Prettify markdown in neovim
		'MeanderingProgrammer/render-markdown.nvim',
		ft = ft_util.document_list,
		keys = {
			{ '<leader>ur', '', desc = 'Render Markdown' },
			{ '<leader>urm', function() require('render-markdown').buf_toggle() end, desc = 'Toggle Render Markdown Locally' },
			{ '<leader>urM', function() require('render-markdown').toggle() end, desc = 'Toggle Render Markdown Globally' },
			{ '<leader><leader>m', function() require('render-markdown').buf_toggle() end, desc = 'Toggle Render Markdown Locally' },
			{ '<leader><leader>M', function() require('render-markdown').toggle() end, desc = 'Toggle Render Markdown Globally' },
			{ '<a-o>', require('util.markdown').open_current_buffer_in_obsidian, mode = { 'n', 'i' }, desc = 'Open File in Obsidian' },
		},
		---@type render.md.Config
		opts = {
			file_types = { 'markdown', 'norg', 'rmd', 'org', 'codecompanion', 'copilot-chat' },
			render_modes = { 'n', 'c', 't' },
			anti_conceal = { enabled = false }, -- disable anticursor-based unconceal so cursor row doesn't reveal

			link = { enabled = true },
			html = { enabled = true },
			quote = { repeat_linebreak = true, icon = '│ ' },
			yaml = { enabled = true },

			heading = {
				enabled = true,
				sign = false,
				backgrounds = {},
				left_margin = 2,
				width = 'full',
				atx = true,
				icons = function(ctx) -- { 'H1', 'H2', 'H3', 'H4', 'H5', 'H6' },
					local sep = '  '
					if #ctx.sections == 0 then return 'H' .. ctx.level .. sep end
					local header_no = table.concat(ctx.sections, '.')
					if ctx.level > 1 then header_no = string.rep(' ', ctx.level) .. header_no end
					return header_no .. sep
				end,
			},
			checkbox = {
				enabled = true,
				unchecked = { icon = ' ', highlight = 'RenderMarkdownCheckboxTodo' },
				checked = { icon = ' ', highlight = 'RenderMarkdownCheckboxDone' },
				custom = {
					todo = { raw = '[ ]', rendered = ' ', highlight = 'RenderMarkdownCheckboxTodo' }, -- override default
					canceled = { raw = '[-]', rendered = ' ', highlight = 'RenderMarkdownCheckboxCanceled', scope_highlight = 'RenderMarkdownCheckboxCanceled' },
					in_progress = { raw = '[/]', rendered = ' ', highlight = 'RenderMarkdownCheckboxInProgress' },
				},
			},
			code = {
				enabled = true,
				sign = true,
				inline = true,
				width = 'block',
				border = 'thin',
				inline_pad = 1,
				left_pad = 2,
				right_pad = 2,
				language_left = '██',
			},
			pipe_table = {
				preset = 'round',
				border_enabled = true,
				border_virtual = true,
			},
			bullet = {
				enabled = true,
				icons = { '⬖', '⬗', '⬥', '⬦', '⬩', '♢', '◊' },
				highlight = {
					'RenderMarkdownH1',
					'RenderMarkdownH2',
					'RenderMarkdownH3',
					'RenderMarkdownH4',
					'RenderMarkdownH5',
					'RenderMarkdownH6',
				},
			},

			-- stylua: ignore
			callout = {
				-- 	-- Callouts are a special instance of a 'block_quote' that start with a 'shortcut_link'.
				-- 	-- The key is for healthcheck and to allow users to change its values, value type below.
				-- 	-- | raw        | matched against the raw text of a 'shortcut_link', case insensitive |
				-- 	-- | rendered   | replaces the 'raw' value when rendering                             |
				-- 	-- | highlight  | highlight for the 'rendered' text and quote markers                 |
				-- 	-- | quote_icon | optional override for quote.icon value for individual callout       |
				-- 	-- | category   | optional metadata useful for filtering                              |
				note      = { raw = '[!NOTE]',      rendered = ' 󰋽 Note',      highlight = 'RenderMarkdownInfo',    category = 'github'   },
				tip       = { raw = '[!TIP]',       rendered = ' 󰌶 Tip',       highlight = 'RenderMarkdownSuccess', category = 'github'   },
				important = { raw = '[!IMPORTANT]', rendered = ' 󰅾 Important', highlight = 'RenderMarkdownHint',    category = 'github'   },
				warning   = { raw = '[!WARNING]',   rendered = ' 󰀪 Warning',   highlight = 'RenderMarkdownWarn',    category = 'github'   },
				caution   = { raw = '[!CAUTION]',   rendered = ' 󰳦 Caution',   highlight = 'RenderMarkdownError',   category = 'github'   },
				-- 	-- Obsidian: https://help.obsidian.md/Editing+and+formatting/Callouts
				abstract  = { raw = '[!ABSTRACT]',  rendered = ' 󰨸 Abstract',  highlight = 'RenderMarkdownInfo',    category = 'obsidian' },
				summary   = { raw = '[!SUMMARY]',   rendered = ' 󰨸 Summary',   highlight = 'RenderMarkdownInfo',    category = 'obsidian' },
				tldr      = { raw = '[!TLDR]',      rendered = ' 󰨸 Tldr',      highlight = 'RenderMarkdownInfo',    category = 'obsidian' },
				info      = { raw = '[!INFO]',      rendered = ' 󰋽 Info',      highlight = 'RenderMarkdownInfo',    category = 'obsidian' },
				todo      = { raw = '[!TODO]',      rendered = ' 󰗡 Todo',      highlight = 'RenderMarkdownInfo',    category = 'obsidian' },
				hint      = { raw = '[!HINT]',      rendered = ' 󰌶 Hint',      highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
				success   = { raw = '[!SUCCESS]',   rendered = ' 󰄬 Success',   highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
				check     = { raw = '[!CHECK]',     rendered = ' 󰄬 Check',     highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
				done      = { raw = '[!DONE]',      rendered = ' 󰄬 Done',      highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
				question  = { raw = '[!QUESTION]',  rendered = ' 󰘥 Question',  highlight = 'RenderMarkdownWarn',    category = 'obsidian' },
				help      = { raw = '[!HELP]',      rendered = ' 󰘥 Help',      highlight = 'RenderMarkdownWarn',    category = 'obsidian' },
				faq       = { raw = '[!FAQ]',       rendered = ' 󰘥 Faq',       highlight = 'RenderMarkdownWarn',    category = 'obsidian' },
				attention = { raw = '[!ATTENTION]', rendered = ' 󰀪 Attention', highlight = 'RenderMarkdownWarn',    category = 'obsidian' },
				failure   = { raw = '[!FAILURE]',   rendered = ' 󰅖 Failure',   highlight = 'RenderMarkdownError',   category = 'obsidian' },
				fail      = { raw = '[!FAIL]',      rendered = ' 󰅖 Fail',      highlight = 'RenderMarkdownError',   category = 'obsidian' },
				missing   = { raw = '[!MISSING]',   rendered = ' 󰅖 Missing',   highlight = 'RenderMarkdownError',   category = 'obsidian' },
				danger    = { raw = '[!DANGER]',    rendered = ' 󱐌 Danger',    highlight = 'RenderMarkdownError',   category = 'obsidian' },
				error     = { raw = '[!ERROR]',     rendered = ' 󱐌 Error',     highlight = 'RenderMarkdownError',   category = 'obsidian' },
				bug       = { raw = '[!BUG]',       rendered = ' 󰨰 Bug',       highlight = 'RenderMarkdownError',   category = 'obsidian' },
				example   = { raw = '[!EXAMPLE]',   rendered = ' 󰉹 Example',   highlight = 'RenderMarkdownHint' ,   category = 'obsidian' },
				quote     = { raw = '[!QUOTE]',     rendered = ' 󱆨 Quote',     highlight = 'RenderMarkdownQuote',   category = 'obsidian' },
				cite      = { raw = '[!CITE]',      rendered = ' 󱆨 Cite',      highlight = 'RenderMarkdownQuote',   category = 'obsidian' },
			},

			win_options = {
				showbreak = { rendered = '  ' },
			},
		},
	},
}
