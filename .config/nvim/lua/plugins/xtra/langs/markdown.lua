return {
	{ -- Rendering preview
		'iamcco/markdown-preview.nvim',
		cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
		build = function()
			require('lazy').load { plugins = { 'markdown-preview.nvim' } }
			vim.fn['mkdp#util#install']()
		end,
		ft = { 'markdown', 'mdx' },
		keys = {
			{
				'<leader>cp',
				ft = 'markdown',
				'<cmd>MarkdownPreviewToggle<cr>',
				desc = 'Markdown Preview',
			},
		},
		config = function() vim.cmd [[do FileType]] end,
	},

	{ -- MDX highlighting
		'davidmh/mdx.nvim',
		config = true,
		ft = 'mdx',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
	},
}
