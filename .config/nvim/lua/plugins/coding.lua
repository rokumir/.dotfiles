---@diagnostic disable: no-unknown
return {
	{ -- Delimiter pairs
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		config = {
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

	{ -- Supermaven
		'supermaven-inc/supermaven-nvim',
		event = 'VeryLazy',
		priority = 1000,
		init = function()
			LazyVim.toggle.map(
				'<leader><leader>a',
				LazyVim.toggle.wrap {
					name = 'Smart Suggestion (Supermaven)',
					get = require('supermaven-nvim.api').is_running,
					set = function(s) require('supermaven-nvim.api')[s and 'start' or 'stop']() end,
				}
			)
		end,
		opts = {
			disable_inline_completion = true,
			disable_keymaps = true,
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

	{ -- add my custom snippet dir
		'garymjr/nvim-snippets',
		opts = function(_, opts) opts.search_paths = { vim.fn.stdpath 'config' .. '/misc/snippets' } end,
	},
}
