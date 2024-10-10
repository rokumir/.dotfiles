return {
	'nvim-treesitter/nvim-treesitter',
	opts = {
		ensure_installed = {
			'astro',
			'cmake',
			'cpp',
			'css',
			'fish',
			'gitignore',
			'go',
			'graphql',
			'http',
			'java',
			'php',
			'rust',
			'scss',
			'sql',
			'svelte',
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
		filetypes = { -- vim settings
			pattern = {
				['${TMUX_HARPOON_CACHE_FILE}'] = 'tmux-harpoon',
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
		---@type table<string, string|string[]>
		treesitter = {
			markdown = 'mdx',
			-- sh = { 'tmux-harpoon', 'dotenv' },
		},
	},
	config = function(_, opts)
		require('nvim-treesitter.configs').setup(opts)

		vim.filetype.add(opts.filetypes)

		---@param lang string
		---@param ft string|string[]
		for lang, ft in pairs(opts.treesitter) do
			vim.treesitter.language.register(lang, ft)
		end
	end,
}
