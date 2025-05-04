---@module 'lazy'
---@type table<number, LazyPluginSpec>
return {
	{ -- Treesitter
		'nvim-treesitter/nvim-treesitter',
		opts = {
			ensure_installed = {
				'css',
				'fish',
				'gitignore',
				'go',
				'http',
				'scss',
				'sql',
			},

			-- matchup = {
			--     enable = true,
			-- },

			-- https://github.com/nvim-treesitter/playground#query-linter
			query_linter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { 'BufWrite', 'CursorHold' },
			},

			-- my custom options
			--- Registers filetypes/files/path_to_file to langs
			filetypes = { -- vim settings
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
					mdx = 'mdx',
					tmux = 'tmux',
				},
			},

			--- Registers SYNTAX for filetypes to langs
			-- {exist_lang} = [registered_filetypes]
			---@type table<string, string|string[]>
			treesitter = {
				markdown = 'mdx',
				bash = { 'tmux-harpoon', 'dotenv' },
				javascript = 'dataviewjs',
				json = 'jsonl',
			},
		},
		config = function(_, opts)
			require('nvim-treesitter.configs').setup(opts)

			vim.filetype.add(opts.filetypes)

			---@diagnostic disable-next-line: no-unknown
			for lang, ft in pairs(opts.treesitter) do
				vim.treesitter.language.register(lang, ft)
			end
		end,
	},
}
