---@diagnostic disable: missing-fields
local document_fts = require('utils.const').filetype.document_list

return {
	-- MDX highlighting
	{ 'davidmh/mdx.nvim', ft = 'mdx' },

	{ -- Live preview
		'iamcco/markdown-preview.nvim',
		cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
		build = function()
			require('lazy').load { plugins = { 'markdown-preview.nvim' } }
			vim.fn['mkdp#util#install']()
		end,
		ft = document_fts,
		keys = {
			{ '<leader>uM', '<cmd>MarkdownPreviewToggle<cr>', ft = 'markdown', desc = 'Markdown Preview' },
		},
		config = function() vim.cmd [[do FileType]] end,
	},

	{ -- Prettify markdown in neovim
		'MeanderingProgrammer/render-markdown.nvim',
		ft = { 'markdown', 'norg', 'rmd', 'org', 'codecompanion' },
		opts = {
			code = {
				sign = false,
				width = 'block',
				right_pad = 1,
			},
			heading = {
				sign = false,
				icons = {},
			},
			checkbox = {
				enabled = false,
			},
		},
		config = function(_, opts)
			require('render-markdown').setup(opts)
			Snacks.toggle({
				name = 'Render Markdown',
				get = function() return require('render-markdown.state').enabled end,
				set = function(enabled)
					local m = require 'render-markdown'
					if enabled then
						m.enable()
					else
						m.disable()
					end
				end,
			}):map '<leader>um'
		end,
	},
}
