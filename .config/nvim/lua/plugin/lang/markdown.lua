local Mapkey = Nihil.keymap
local Vault = Nihil.config.vault

local DATE_FORMAT = '%Y-%m-%d'
local TIME_FORMAT = '%H:%M:%S'
local DATETIME_FORMAT = DATE_FORMAT .. 'T' .. TIME_FORMAT
local TEMPLATES_DIR = '.meta/templates'

local function is_note_dir_matches() return Nihil.path.is_current_matches(Vault.second_brain) end
local function get_time_now_fn(format, offset_hours)
	return function() return tostring(os.date(format, os.time() - (offset_hours or 0) * 60 * 60)) end
end

local note_dir_visited = false
vim.api.nvim_create_autocmd('DirChanged', {
	group = Nihil.augroup 'obsidian_lazy_load',
	callback = function()
		if not note_dir_visited and is_note_dir_matches() then
			note_dir_visited = true
			vim.cmd 'Lazy load obsidian.nvim'
			Nihil.keymap.mapper.set('<c-e>', 'n')
			Mapkey { '<c-e>', Nihil.markdown.obsidian.quick_switcher, desc = 'Quick Switcher' }
		elseif note_dir_visited then
			note_dir_visited = false
			Mapkey(Nihil.keymap.mapper.get('<c-e>', 'n'))
		end
	end,
})

---@module 'lazy'
---@type LazyPluginSpec[]
return {
	{ 'davidmh/mdx.nvim', ft = 'mdx' }, -- Treesitter for MDX files

	{ -- Prettify markdown in neovim
		'MeanderingProgrammer/render-markdown.nvim',
		ft = Nihil.config.exclude.document_filetypes,
		init = function() vim.g.markdown_folding = 1 end,
		keys = {
			{ '<leader><leader>rr', function() require('render-markdown').buf_toggle() end, desc = 'Toggle Render Markdown [Local]', ft = { 'markdown', 'mdx' } },
			{ '<leader><leader>rR', function() require('render-markdown').toggle() end, desc = 'Toggle Render Markdown [Global]', ft = { 'markdown', 'mdx' } },
		},
		---@type render.md.Config|table<string, unknown|{}>
		opts = {
			file_types = { 'markdown', 'norg', 'rmd', 'org', 'codecompanion', 'copilot-chat' },
			render_modes = { 'n', 'c', 't' },
			anti_conceal = { enabled = false }, -- disable anticursor-based unconceal so cursor row doesn't reveal

			html = { enabled = true },
			yaml = { enabled = true },
			quote = { repeat_linebreak = true, icon = '│ ' },

			link = {
				enabled = true,
				custom = {
					pdf = { kind = 'suffix', pattern = '. pdf', icon = ' ' },
				},
			},

			completions = {
				lsp = { enabled = true },
				blink = { enabled = true },
			},

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
				-- Callouts are a special instance of a 'block_quote' that start with a 'shortcut_link'.
				-- The key is for healthcheck and to allow users to change its values, value type below.
				-- | raw        | matched against the raw text of a 'shortcut_link', case insensitive |
				-- | rendered   | replaces the 'raw' value when rendering                             |
				-- | highlight  | highlight for the 'rendered' text and quote markers                 |
				-- | quote_icon | optional override for quote.icon value for individual callout       |
				-- | category   | optional metadata useful for filtering                              |
				note      = { raw = '[!NOTE]',      rendered = ' 󰋽 Note',      highlight = 'RenderMarkdownInfo',    category = 'github'   },
				tip       = { raw = '[!TIP]',       rendered = ' 󰌶 Tip',       highlight = 'RenderMarkdownSuccess', category = 'github'   },
				important = { raw = '[!IMPORTANT]', rendered = ' 󰅾 Important', highlight = 'RenderMarkdownHint',    category = 'github'   },
				warning   = { raw = '[!WARNING]',   rendered = ' 󰀪 Warning',   highlight = 'RenderMarkdownWarn',    category = 'github'   },
				caution   = { raw = '[!CAUTION]',   rendered = ' 󰳦 Caution',   highlight = 'RenderMarkdownError',   category = 'github'   },
				-- Obsidian: https://help.obsidian.md/Editing+and+formatting/Callouts
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
				showbreak = { default = '  ', rendered = '  ' },
			},
		},
	},

	{ -- Obsdiian
		'obsidian-nvim/obsidian.nvim',
		version = false,
		lazy = not is_note_dir_matches(),
		---@module 'obsidian'
		---@type obsidian.config
		opts = {
			workspaces = {
				{ name = 'cortex', path = Vault.second_brain },
			},
			frontmatter = {
				enabled = true,
				func = function(note)
					local out = require('obsidian.builtin').frontmatter(note)
					out.modified = get_time_now_fn(DATETIME_FORMAT)()
					return out
				end,
				sort = {
					'icon',
					'title',
					'aliases',
					'categories',
					'tags',
					'created',
					'modified',
					'id',
				},
			},
			checkbox = {
				enabled = true,
				create_new = true,
				order = { ' ', '/', 'x', '-' },
			},
			comment = { enabled = true },
			ui = {
				enable = false,
				enabled = false,
				ignore_conceal_warn = true,
			},
			statusline = {
				enabled = true,
				format = '{{backlinks}} backlinks',
			},

			attachments = {
				img_folder = '.assets/imgs',
				confirm_img_paste = true,
			},

			daily_notes = {
				folder = 'journal',
				date_format = DATE_FORMAT .. '-%A',
				alias_format = '%A %B %-d, %Y',
				default_tags = { 'journal' },
				workdays_only = false,
				template = '.meta/templates/Daily.md',
			},

			templates = {
				folder = TEMPLATES_DIR,
				date_format = DATE_FORMAT,
				time_format = TIME_FORMAT,
				substitutions = {
					yesterday = get_time_now_fn(DATE_FORMAT, 86400),
					datetime = get_time_now_fn(DATETIME_FORMAT),
					now = get_time_now_fn(DATETIME_FORMAT),
					today = get_time_now_fn '%A %B %-d, %Y',
				},
			},

			callbacks = {
				post_setup = function()
					local function action(a) return '<cmd>Obsidian ' .. a .. ' <cr>' end
					Mapkey {
						{ '<c-e>', Nihil.markdown.obsidian.quick_switcher, desc = 'Quick Switcher' },

						{ '<leader>o', group = 'Obsidian', icon = '💎' },
						{ '<leader>of', Nihil.markdown.obsidian.quick_switcher, desc = 'Quick Switcher' },
						{ '<leader>on', action 'new', desc = 'New Note', icon = '󰎜' },
						{ '<leader>oN', action 'new_from_template', desc = 'New Note From Template', icon = '' },
						{ '<c-s-n>', action 'new_from_template', desc = 'New Note From Template', icon = '' },
						{ '<leader>oo', group = 'Open Note', icon = '󱙓' },
						{ '<leader>oop', action 'search', desc = 'Search', icon = '󰍉' },
						{ '<leader>oot', action 'today', desc = 'Today', icon = '󰃶' },
						{ '<leader>ooT', action 'tomorrow', desc = 'Tomorrow', icon = '' },
						{ '<leader>ooy', action 'yesterday', desc = 'Yesterday', icon = '' },
						{ '<leader>ot', action 'tags', desc = 'Tags', icon = '' },
						{ '<leader>ol', action 'links', desc = 'links', icon = '' },
						{ '<leader>ob', action 'backlinks', desc = 'Backlinks', icon = '' },
						{ 'gr', action 'backlinks', desc = 'Obsidian Backlinks', icon = '' },
						{ 'gd', action 'follow_link', desc = 'Obsidian Follow Link', icon = '' },
						{ '<leader>oT', action 'toc', desc = 'TOC', icon = '' },
						{ '<leader>oW', action 'workspace', desc = 'Switch Workspace', icon = '' },
						{ '<leader>fr', action 'rename', desc = 'Obsidian Rename', icon = '' },
						{ '<leader>oR', action 'rename', desc = 'Rename', icon = '' },
						{ '<c-enter>', action 'toggle_checkbox', mode = { 'n', 'v' }, desc = 'Obsidian Cycle Through Checkbox Options', icon = '' },
						{
							mode = 'v',
							icon = '',
							{ '<leader>ol', action 'link', desc = 'Link Selection To A Note' },
							{ '<leader>oL', action 'link_new', desc = 'Link to Selection In A New Note' },
							{ '<leader>oe', action 'extract_node', desc = 'Put Selection In New Note & Link to it' },
						},
					}
				end,
			},
		},
	},
}
