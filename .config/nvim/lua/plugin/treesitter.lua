---@module 'lazy'
---@type LazyPluginSpec[]
return {
	{ -- Treesitter
		'nvim-treesitter/nvim-treesitter',
		version = false,
		optional = true,
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				'css',
				'fish',
				'gitignore',
				'go',
				'http',
				'scss',
				'sql',
				'html',
			})

			--- Registers filetypes/files/path_to_file to langs
			vim.filetype.add { -- vim settings
				pattern = {
					['%.dataviewjs'] = 'dataviewjs',
					['%.tmux%-harpoon%-sessions'] = 'tmux-harpoon',
					['%.env%.[%w_.-]+'] = 'dotenv',
				},
				filename = {
					['.env'] = 'dotenv',
					['.ignore'] = 'gitignore',
					['Podfile'] = 'ruby',
				},
				extension = {
					-- mdx = 'mdx',
					tmux = 'tmux',
					gitconfig = 'gitconfig',
				},
			}

			--- Registers SYNTAX for filetypes to langs
			for lang, ft in pairs { -- lang = registered_filetypes
				markdown = 'mdx',
				bash = { 'tmux-harpoon', 'dotenv' },
				javascript = 'dataviewjs',
				json = 'jsonl',
			} do
				vim.treesitter.language.register(lang, ft)
			end
		end,
	},

	{ -- cool context
		'nvim-treesitter/nvim-treesitter-context',
		priority = 1000,
		version = false,
		keys = {
			{ '<leader>ut', function() require('treesitter-context').toggle() end, desc = 'Toggle Treesitter Context' },
		},
		opts = {
			enable = false,
			mode = 'cursor',
			max_lines = 3,
			separator = '',
			playground = { enable = true },
		},
	},

	{ 'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle' },
}
