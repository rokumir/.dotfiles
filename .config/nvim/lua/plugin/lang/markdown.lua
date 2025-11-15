---@diagnostic disable: missing-fields
local ft_util = require 'config.const.filetype'
local project_dir = require 'config.const.project_dirs'

local DATE_FORMAT = '%Y-%m-%d'
local TIME_FORMAT = '%H:%M:%S'

local map_key = require('util.keymap').map
local function is_note_pwd() return require('util.path').is_matches { project_dir.second_brain, project_dir.second_brain_OLD } end
local function get_time_now_fn(template, offset_hours) return tostring(os.date(template, os.time() - (offset_hours or 0) * 60 * 60)) end

---@type LazyPluginSpec[]
return {
	{ 'davidmh/mdx.nvim', ft = 'mdx' }, -- Treesitter for MDX files

	{ -- Prettify markdown in neovim
		'MeanderingProgrammer/render-markdown.nvim',
		ft = ft_util.document_list,
		keys = function()
			map_key {
				{ '<leader>ur', group = 'Render Markdown' },
				{ '<leader>urm', function() require('render-markdown').buf_toggle() end, desc = 'Toggle Render Markdown Locally' },
				{ '<leader>urM', function() require('render-markdown').toggle() end, desc = 'Toggle Render Markdown Globally' },
				{ '<leader><leader>m', function() require('render-markdown').buf_toggle() end, desc = 'Toggle Render Markdown Locally' },
				{ '<leader><leader>M', function() require('render-markdown').toggle() end, desc = 'Toggle Render Markdown Globally' },
			}
			return {}
		end,
		---@type render.md.Config
		opts = {
			file_types = { 'markdown', 'norg', 'rmd', 'org', 'codecompanion', 'copilot-chat' },
			render_modes = { 'n', 'c', 't' },
			anti_conceal = { enabled = false }, -- disable anticursor-based unconceal so cursor row doesn't reveal

			link = { enabled = true },
			html = { enabled = true },
			yaml = { enabled = true },
			quote = { repeat_linebreak = true, icon = '│ ' },
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
				showbreak = { rendered = '  ' },
			},
		},
	},

	{ -- Obsdiian
		'obsidian-nvim/obsidian.nvim',
		version = false,
		lazy = not is_note_pwd(),
		---@module 'obsidian'
		---@type obsidian.config
		opts = {
			workspaces = {
				{ name = 'nihil', path = project_dir.second_brain },
				{ name = 'notes', path = project_dir.second_brain_OLD },
			},
			frontmatter = { enabled = true, sort = {
				'icon',
				'title',
				'aliases',
				'categories',
				'tags',
				'created',
				'id',
			} },
			checkbox = {
				enabled = true,
				create_new = true,
				order = { ' ', '/', '-', 'x' },
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

			daily_notes = {
				folder = 'journal',
				date_format = DATE_FORMAT .. '-%A',
				alias_format = '%A %B %-d, %Y',
				default_tags = { 'journal' },
				workdays_only = false,
				template = '.meta/templates/Daily.md',
			},

			templates = {
				folder = '.meta/templates',
				date_format = DATE_FORMAT,
				time_format = TIME_FORMAT,
				substitutions = {
					yesterday = get_time_now_fn(DATE_FORMAT, 86400),
					datetime = get_time_now_fn(DATE_FORMAT .. 'T' .. TIME_FORMAT),
					now = get_time_now_fn(DATE_FORMAT .. 'T' .. TIME_FORMAT),
					today = get_time_now_fn '%A %B %-d, %Y',
				},
			},

			callbacks = {
				post_setup = function()
					local function action(a) return '<cmd>Obsidian ' .. a .. ' <cr>' end
					map_key {
						'<leader>o',
						group = 'Obsidian',
						icon = '💎',
						{ '<leader>on', action 'new', desc = 'New Note', icon = '󰎜' },
						{ '<c-n>', action 'new', desc = 'Obsidian New Note', icon = '󰎜' },
						{ '<leader>oN', action 'new_from_template', desc = 'New Note From Template', icon = '' },
						{ '<c-s-n>', action 'new_from_template', desc = 'Obsidian New Note', icon = '' },
						{ '<leader>op', group = 'Open Note', icon = '󱙓' },
						{ '<leader>opp', action 'search', desc = 'Search', icon = '󰍉' },
						{ '<leader>opt', action 'today', desc = 'Today', icon = '󰃶' },
						{ '<leader>opT', action 'tomorrow', desc = 'Tomorrow', icon = '' },
						{ '<leader>opy', action 'yesterday', desc = 'Yesterday', icon = '' },
						{ '<leader>ot', action 'tags', desc = 'Tags', icon = '' },
						{ ';T', action 'tags', desc = 'Obsidian Tags', icon = '' },
						{ '<leader>ol', action 'links', desc = 'links', icon = '' },
						{ '<leader>ob', action 'backlinks', desc = 'Backlinks', icon = '' },
						{ 'gr', action 'backlinks', desc = 'Obsidian Backlinks', icon = '' },
						{ 'gd', action 'follow_link', desc = 'Obsidian Follow Link', icon = '' },
						{ '<leader>oT', action 'toc', desc = 'TOC', icon = '' },
						{ '<leader>oW', action 'workspace', desc = 'Switch Workspace', icon = '' },
						{ '<leader>fr', action 'rename', desc = 'Obsidian Rename', icon = '' },
						{ '<leader>oR', action 'rename', desc = 'Rename', icon = '' },
						{ '<c-enter>', action 'toggle_checkbox', mode = { 'n', 'v' }, desc = 'Obsidian Cycle Through Checkbox Options', icon = '' },
						{ '<c-e>', '<cmd>SnacksNotesQuickSwitcher <cr>', desc = 'Quick Switch' },
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
		---@param opts obsidian.config
		config = function(_, opts)
			require('obsidian').setup(opts)

			local function is_in_template_dir(file) ---@param file string
				-- stylua: ignore
				return opts.templates
					and opts.templates.folder
					and file:match('^' .. opts.templates.folder) ~= nil
			end

			vim.api.nvim_create_user_command('SnacksNotesQuickSwitcher', function()
				local obsidian_ok, obsidian_note = pcall(require, 'obsidian.note')
				local get_note_info = obsidian_ok and obsidian_note.from_file or error '**[Obsidian.nvim]** plugin not found!'

				Snacks.picker.files {
					source = 'markdown_notes_quick_switcher',
					title = '󱀂 Notes',
					layout = 'vscode_focus',
					ft = { 'markdown', 'mdx', 'md' },
					transform = function(item)
						vim.defer_fn(function()
							local note = get_note_info(item.file, { collect_anchor_links = false, collect_blocks = false, load_contents = false, max_lines = 100 })
							if not note.has_frontmatter or is_in_template_dir(item.file) then return end
							vim.validate('note.aliases', note.aliases, 'table')
							vim.validate('note.tags', note.tags, 'table')

							item.fm = {
								icon = note.metadata.icon,
								title = type(note.metadata.title) == 'string' and note.metadata.title or note.aliases[1] or nil,
								aliases = #note.aliases > 0 and table.concat(note.aliases, '') or nil,
								tags = #note.tags > 0 and table.concat(note.tags, '') or nil,
							}
							item.text = Snacks.picker.util.text(item.fm, { 'title', 'tags', 'aliases' })
						end, 0)
					end,
					---@type snacks.picker.format
					format = function(item, picker)
						local fm = item.fm
						if not fm then return require('snacks.picker.format').filename(item, picker) end

						local ret = {}
						local sep = { ' ' }

						local ft_icon = Snacks.picker.util.align(fm.icon or '󰍔', 3)
						table.insert(ret, { ft_icon, 'SnacksPickerIcon', virtual = true })

						if fm.title then
							vim.list_extend(ret, {
								{ fm.title, 'SnacksPickerFile', field = 'file' },
								sep,
								{ item.file, 'SnacksPickerDir', field = 'file' },
							})
						else
							local base_filename = vim.fn.fnamemodify(item.file, ':t')
							vim.list_extend(ret, {
								{ base_filename, 'SnacksPickerFile', field = 'file' },
								sep,
								{ item.file:gsub('/' .. base_filename, ''), 'SnacksPickerDir', field = 'file' },
							})
						end

						if fm.tags then vim.list_extend(ret, {
							sep,
							{ fm.tags, 'SnacksPickerDir', field = 'tags' },
						}) end

						if fm.aliases then vim.list_extend(ret, {
							sep,
							{ fm.aliases, 'SnacksPickerDir', field = 'aliases' },
						}) end

						return ret
					end,
				}
			end, { desc = 'Open Notes Quick Switcher' })
		end,
	},
}
