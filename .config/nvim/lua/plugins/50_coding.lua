---@diagnostic disable: no-unknown, missing-fields
---@type table<number, LazyPluginSpec>
return {
	{ -- Delimiter pairs
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		opts = { disable_in_visualblock = true },
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

	{ -- Refactoring (primeagen)
		'ThePrimeagen/refactoring.nvim',
		keys = function()
			return {
				{ '<leader>r', '', desc = 'refactor' },
				{
					'<leader>rs',
					function()
						local fzf_lua = require 'fzf-lua'
						local results = require('refactoring').get_refactors()
						local refactoring = require 'refactoring'
						fzf_lua.fzf_exec(results, {
							fzf_opts = {},
							fzf_colors = true,
							actions = {
								['default'] = function(selected) refactoring.refactor(selected[1]) end,
							},
						})
					end,
					mode = 'v',
					desc = 'Refactor',
				},
				{
					'<leader>ri',
					function() require('refactoring').refactor 'Inline Variable' end,
					mode = { 'n', 'v' },
					desc = 'Inline Variable',
				},
				{ '<leader>rb', function() require('refactoring').refactor 'Extract Block' end, desc = 'Extract Block' },
				{ '<leader>rf', function() require('refactoring').refactor 'Extract Block To File' end, desc = 'Extract Block To File' },
				{ '<leader>rf', function() require('refactoring').refactor 'Extract Function' end, mode = 'v', desc = 'Extract Function' },
				{
					'<leader>rF',
					function() require('refactoring').refactor 'Extract Function To File' end,
					mode = 'v',
					desc = 'Extract Function To File',
				},
				{ '<leader>rx', function() require('refactoring').refactor 'Extract Variable' end, mode = 'v', desc = 'Extract Variable' },
				{ '<leader>rp', function() require('refactoring').debug.print_var { normal = true } end, desc = 'Debug Print Variable' },
				{ '<leader>rp', function() require('refactoring').debug.print_var {} end, mode = 'v', desc = 'Debug Print Variable' },
				{ '<leader>rP', function() require('refactoring').debug.printf { below = false } end, desc = 'Debug Print' },
				{ '<leader>rc', function() require('refactoring').debug.cleanup {} end, desc = 'Debug Cleanup' },
			}
		end,
	},

	{ -- Tabout
		'kawre/neotab.nvim',
		event = 'InsertEnter',
		opts = {
			tabkey = '<tab>',
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
			},
		},
	},

	{ -- better rename
		'saecki/live-rename.nvim',
		priority = 1000,
		event = 'VeryLazy',
		opts = {
			prepare_rename = true,
			request_timeout = 2000,
			show_other_ocurrences = true,
			use_patterns = true,
			keys = {
				submit = {
					{ 'n', '<cr>' },
					{ 'v', '<cr>' },
					{ 'i', '<cr>' },
					{ 'n', '<c-j>' },
					{ 'v', '<c-j>' },
					{ 'i', '<c-j>' },
					{ 'n', '<c-l>' },
					{ 'v', '<c-l>' },
					{ 'i', '<c-l>' },
				},
				cancel = {
					{ 'n', '<esc>' },
					{ 'n', 'q' },
					{ 'n', '<c-q>' },
					{ 'v', '<c-q>' },
					{ 'i', '<c-q>' },
				},
			},
			hl = {
				current = 'CurSearch',
				others = 'Search',
			},
		},
	},

	{ -- AI suggestion/completion (A.I, copilot, chatgpt)
		'zbirenbaum/copilot.lua',
		optional = true,
		keys = {
			{
				'<leader><leader>C',
				function()
					require('copilot.suggestion').toggle_auto_trigger()
					LazyVim.info 'Copilot suggestion toggled!'
				end,
				desc = '  Copilot: Suggestion Toggle',
			},
		},
		dependencies = {
			'saghen/blink.cmp',
			optional = true,
			dependencies = {
				{ 'giuxtaposition/blink-cmp-copilot', enabled = false }, -- diable
				{ 'fang2hou/blink-copilot', opts = { max_completions = 2, max_attempts = 3 } },
			},
			priority = 1000,
			opts = {
				sources = {
					default = { 'copilot' },
					providers = {
						copilot = {
							name = 'copilot',
							module = 'blink-copilot',
							score_offset = 100,
							max_items = 4,
							min_keyword_length = 4,
							async = true,
						},
					},
				},
			},
		},

		---@type CopilotConfig
		opts = {
			panel = { enabled = false },
			suggestion = { enabled = false },
		},
	},

	-- { -- AI Chat
	-- 	'olimorris/codecompanion.nvim',
	--
	-- 	keys = {
	-- 		{ '<c-P>', '<cmd>CodeCompanionActions<cr>', desc = 'CodeCompanion: Actions' },
	-- 		{ '<leader>C', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'CodeCompanion: Chat Toggle' },
	-- 	},
	--
	-- 	---@module 'codecompanion'
	-- 	opts = {
	-- 		---@type CodeCompanion.Strategies
	-- 		strategies = {
	-- 			chat = {
	-- 				adapter = 'copilot',
	-- 				opts = { completion_provider = 'default' },
	-- 			},
	-- 			inline = { adapter = 'copilot' },
	-- 			cmd = { adapter = 'copilot' },
	-- 		},
	--
	-- 		---@type CodeCompanion
	-- 		adapters = {
	-- 			opts = {
	-- 				show_model_choices = true,
	-- 			},
	-- 		},
	--
	-- 		display = {
	-- 			action_palette = {
	-- 				width = 95,
	-- 				height = 10,
	-- 				opts = {
	-- 					show_default_actions = true, -- Show the default actions in the action palette?
	-- 					show_default_prompt_library = true, -- Show the default prompt library in the action palette?
	-- 				},
	-- 			},
	--
	-- 			chat = {
	-- 				show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
	-- 				separator = '─', -- The separator between the different messages in the chat buffer
	-- 				show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
	-- 				show_settings = false, -- Show LLM settings at the top of the chat buffer?
	-- 				show_token_count = true, -- Show the token count for each response?
	-- 				start_in_insert_mode = true, -- Open the chat buffer in insert mode?
	-- 			},
	-- 		},
	--
	-- 		opts = {
	-- 			-- Set debug logging.
	-- 			-- NOTE: By default, logs are stored at ~/.local/state/nvim/codecompanion.log
	-- 			log_level = 'DEBUG', ---@type 'DEBUG'|'INFO'|'WARN'|'ERROR'
	--
	-- 			-- language = 'English',
	--
	-- 			-- Prevent any code from being sent to the LLM.
	-- 			-- NOTE: Whilst the plugin makes every attempt to prevent code
	-- 			-- from being sent to the LLM, use this option at your own risk.
	-- 			send_code = false,
	--
	-- 			------@param opts CodeCompanion.Command.Opts
	-- 			---system_prompt = function(opts) return 'My new system prompt' end,
	-- 		},
	-- 	},
	-- },
}
