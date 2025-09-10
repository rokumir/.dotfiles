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
		ft = { 'markdown', 'norg', 'rmd', 'org', 'codecompanion', 'copilot-chat' },
		opts = {
			render_modes = true,
			heading = {
				sign = true,
				signs = { '󰫎 ' },
				-- icons = { 'H1', 'H2', 'H3', 'H4', 'H5', 'H6' },
				icons = function(sections)
					table.remove(sections, 1)
					if #sections > 0 then return table.concat(sections, '.') .. '. ' end
				end,
				backgrounds = {},
				top_pad = 1,
				left_pad = 1,
			},
			code = {
				sign = false,
				width = 'block',
				right_pad = 1,
			},
			checkbox = { enabled = false },
			quote = {
				repeat_linebreak = true,
			},

			win_options = {
				showbreak = {
					default = '',
					rendered = '  ',
				},
				breakindent = {
					default = false,
					rendered = true,
				},
				breakindentopt = {
					default = '',
					rendered = '',
				},
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
