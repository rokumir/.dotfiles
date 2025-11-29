return {
	'folke/snacks.nvim',
	keys = {
		{ '<leader>.', function() Snacks.scratch() end, desc = 'Scratch: Toggle Buffer' },
		{ '<leader>S', function() Snacks.scratch { ft = 'markdown', name = 'Todo' } end, desc = 'Scratch: Todo' },
		{ ';s.', function() Snacks.scratch.select() end, desc = 'Scratch: Select Buffer' },
	},
	---@type snacks.Config
	opts = {
		styles = {
			scratch = {
				width = 0.8,
				height = 0.8,
				bo = { buftype = '', buflisted = false, bufhidden = 'hide', swapfile = false },
				minimal = false,
				noautocmd = false,
				-- position = "right",
				zindex = 20,
				wo = { winhighlight = 'NormalFloat:Normal' },
				border = 'rounded',
				title_pos = 'center',
				footer_pos = 'center',
			},
		},
		scratch = {
			win = {
				max_height = 25,
				keys = {
					q = false,
					delete_file = {
						'<a-D>',
						function(self) Nihil.file.delete(self.buf) end,
						desc = 'Delete Scratch File',
						mode = { 'i', 'n' },
					},
				},
			},
		},
	},
}
