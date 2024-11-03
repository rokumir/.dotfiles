---@diagnostic disable: no-unknown
return {
	{ -- Delimiter pairs
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		opts = {
			disable_in_visualblock = true,
		},
	},

	{ -- Delimiter pairs surroundability
		'kylechui/nvim-surround',
		version = false,
		lazy = false,
		keys = {
			{ 'sa', desc = 'Add Surround', mode = { 'v', 'n' } },
			{ 'sc', desc = 'Delete Surround', mode = { 'v', 'n' } },
			{ 'sd', desc = 'Change Surround' },
		},
		opts = {
			keymaps = {
				visual = 'sa',
				change = 'sc',
				delete = 'sd',
				insert = false,
				insert_line = false,
				normal = false,
				normal_cur = false,
				normal_line = false,
				normal_cur_line = false,
				visual_line = false,
				change_line = false,
			},
		},
	},

	{ -- Change case
		'gregorias/coerce.nvim',
		enabled = false,
		keys = {
			{ 'cs', desc = 'Change Case', mode = { 'n', 'x' } },
			{ 'gcs', desc = 'Change Case Motion', mode = 'o' },
		},
		opts = {
			default_mode_keymap_prefixes = {
				normal_mode = 'cs',
				visual_mode = 'cs',
				motion_mode = 'gcs',
			},
		},
		config = function(_, opts)
			local c = require 'coerce.case'
			local coerce_str = require 'coerce.string'

			require('coerce').setup(vim.tbl_deep_extend('force', {}, opts, {
				cases = {
					{ keymap = 'c', case = c.to_camel_case, description = 'camelCase' },
					{ keymap = '.', case = c.to_dot_case, description = 'dot.case' },
					{ keymap = 'k', case = c.to_kebab_case, description = 'dash-case' },
					{ keymap = 'p', case = c.to_pascal_case, description = 'PascalCase' },
					{ keymap = 's', case = c.to_snake_case, description = 'snake_case' },
					{ keymap = 'n', case = c.to_numerical_contraction, description = 'numeronym (n7m)' },
					{ keymap = '/', case = c.to_path_case, description = 'path/case' },
					{ keymap = 'C', case = c.to_upper_case, description = 'UPPER CASE' },
					{
						keymap = ' ',
						case = function(str)
							local parts = c.split_keyword(str)
							return table.concat(parts, ' ')
						end,
						description = 'space case',
					},
					{
						keymap = 'j',
						case = function(str)
							if str:match '[^%w%s]' then
								local parts = {}
								for word in str:gmatch '%S+' do
									table.insert(parts, word)
								end
								return table.concat(parts, '_')
							end
						end,
						description = 'Join (whitespaces)',
					},
					{
						keymap = 't',
						case = function(str)
							local parts = c.split_keyword(str)

							for i = 1, #parts, 1 do
								local part_graphemes = coerce_str.str2graphemelist(parts[i])
								part_graphemes[1] = vim.fn.toupper(part_graphemes[1])
								parts[i] = table.concat(part_graphemes, '')
							end

							return table.concat(parts, ' ')
						end,
						description = 'Title Case',
					},
				},
			}))
		end,
	},

	{ -- Add my custom snippet dir
		'garymjr/nvim-snippets',
		opts = function(_, opts) opts.search_paths = { vim.fn.stdpath 'config' .. '/misc/snippets' } end,
	},

	{ -- Copilot code completion
		'zbirenbaum/copilot.lua',
		priority = 1000,
		lazy = false,
		keys = {
			{ '<leader><leader>a', '<cmd>Copilot toggle <cr>', silent = true, desc = 'Toggle Copilot' },
			{
				'<a-L>',
				function()
					require('copilot.suggestion').toggle_auto_trigger()
					vim.notify 'Toggle Copilot Auto Trigger'
				end,
				silent = true,
				desc = 'Toggle Copilot Auto Trigger',
			},
		},
		opts = {
			panel = { enabled = false },
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = true,
				debounce = 75,
				keymap = {
					accept = '<m-h>',
					accept_word = '<m-l>',
					accept_line = '<m-L>',
					next = '<m-]>',
					prev = '<m-[>',
					dismiss = '<c-[>',
				},
			},
			filetypes = {
				['copilot-chat'] = true,
				yaml = false,
				terminal = false,
				help = false,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				['.'] = false,
			},
			server_opts_overrides = {},
		},
	},

	{ -- Copilot chat UI
		'CopilotC-Nvim/CopilotChat.nvim',
		branch = 'canary',
		build = 'make tiktoken', -- Only on MacOS or Linux
		lazy = true,
		cmd = 'CopilotChat',
		keys = {
			{ '<c-a-l>', '<cmd>CopilotChatToggle <cr>', silent = true, desc = 'Copilot Chat' },
		},
		opts = {
			debug = false, -- Enable debug logging
			allow_insecure = false, -- Allow insecure server connections

			model = 'claude-3.5-sonnet', -- GPT model to use, 'gpt-3.5-turbo', 'gpt-4', or 'gpt-4o'
			temperature = 0.1, -- GPT temperature

			--question_header = '## User ', -- Header to use for user questions
			--answer_header = '## Copilot ', -- Header to use for AI answers
			--error_header = '## Error ', -- Header to use for errors
			--separator = '───', -- Separator to use in chat

			show_folds = true, -- Shows folds for sections in chat
			show_help = true, -- Shows help message as virtual lines when waiting for user input
			auto_follow_cursor = true, -- Auto-follow cursor in chat
			auto_insert_mode = false, -- Automatically enter insert mode when opening window and on new prompt
			insert_at_end = false, -- Move cursor to end of buffer when inserting text
			clear_chat_on_new_prompt = false, -- Clears chat on every new prompt
			highlight_selection = true, -- Highlight selection in the source buffer when in the chat window

			context = nil, -- Default context to use,
			-- 'buffers', 'buffer' or none (can be specified manually in prompt via @).
			history_path = vim.fn.stdpath 'data' .. '/copilotchat_history', -- Default path to stored history
			--callback = nil, -- Callback to use when ask response is received

			-- default selection (visual or line)
			--selection = function(source) return select.visual(source) or select.line(source) end,

			-- default prompts
			--prompts = {
			--	Explain = {
			--		prompt = '/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.',
			--	},
			--	Review = {
			--		prompt = '/COPILOT_REVIEW Review the selected code.',
			--		callback = function(response, source)
			--			-- see config.lua for implementation
			--		end,
			--	},
			--	Fix = {
			--		prompt = '/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.',
			--	},
			--	Optimize = {
			--		prompt = '/COPILOT_GENERATE Optimize the selected code to improve performance and readability.',
			--	},
			--	Docs = {
			--		prompt = '/COPILOT_GENERATE Please add documentation comment for the selection.',
			--	},
			--	Tests = {
			--		prompt = '/COPILOT_GENERATE Please generate tests for my code.',
			--	},
			--	FixDiagnostic = {
			--		prompt = 'Please assist with the following diagnostic issue in file:',
			--		selection = select.diagnostics,
			--	},
			--	Commit = {
			--		prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
			--		selection = select.gitdiff,
			--	},
			--	CommitStaged = {
			--		prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
			--		selection = function(source) return select.gitdiff(source, true) end,
			--	},
			--},

			-- default window options
			window = {
				layout = 'horizontal', -- 'vertical', 'horizontal', 'float', 'replace'
				width = 0.5, -- fractional width of parent, or absolute width in columns when > 1
				height = 0.34, -- fractional height of parent, or absolute height in rows when > 1
				-- Options below only apply to floating windows
				relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
				border = 'rounded', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
				-- row = nil, -- row position of the window, default is centered
				-- col = nil, -- column position of the window, default is centered
				title = 'Copilot Chat', -- title of chat window
				-- footer = nil, -- footer of chat window
				zindex = 1, -- determines if window is on top or below other floating windows
			},

			-- default mappings
			mappings = {
				complete = {
					detail = 'Use @<Tab> or /<Tab> for options.',
					insert = '<Tab>',
				},
				close = {
					normal = 'q',
					insert = '<c-q>',
				},
				reset = {
					normal = '<a-r>',
					insert = '<a-r>',
				},
				submit_prompt = {
					normal = '<c-l>',
					insert = '<c-l>',
				},
				accept_diff = {
					normal = '<c-d>',
					insert = '<c-d>',
				},
				yank_diff = {
					normal = '<c-y>',
					register = '"',
				},
				show_diff = {
					normal = 'gd',
				},
				show_system_prompt = {
					normal = 'gp',
				},
				show_user_selection = {
					normal = 'gs',
				},
			},
		},
	},

	{ -- Tabout
		'kawre/neotab.nvim',
		event = 'InsertEnter',
		opts = {
			tabkey = '<Tab>',
			act_as_tab = true,
			behavior = 'nested',
			pairs = {
				{ open = '(', close = ')' },
				{ open = '[', close = ']' },
				{ open = '{', close = '}' },
				{ open = "'", close = "'" },
				{ open = '"', close = '"' },
				{ open = '`', close = '`' },
				{ open = '<', close = '>' },
				{ open = '/', close = '/' },
				{ open = ',', close = ',' },
				{ open = ';', close = ';' },
			},
		},
	},

	-- Automatically set indent settings base on the content of the file
	{ 'tpope/vim-sleuth', event = 'VeryLazy', priority = 1000 },
}
