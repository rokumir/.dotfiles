---- Registers filetypes/files/path_to_file to langs
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

---- Registers langs
local register = vim.treesitter.language.register
register('markdown', 'mdx')
register('bash', { 'tmux-harpoon', 'dotenv' })
register('javascript', 'dataviewjs')
register('json', 'jsonl')

---@module 'lazy'
---@type LazyPluginSpec[]
return {
	{ -- Treesitter
		'nvim-treesitter',
		version = false,
		optional = true,
		opts = {
			ensure_installed = {
				'css',
				'gitignore',
				'go',
				'http',
				'scss',
				'sql',
				'html',
			},
		},
	},

	{ -- cool context
		'nvim-treesitter/nvim-treesitter-context',
		version = false,
		keys = {
			{ '<leader><leader>ut', function() require('treesitter-context').toggle() end, desc = 'Toggle Treesitter Context' },
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
