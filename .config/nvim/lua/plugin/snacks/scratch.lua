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
						function(self)
							local file = vim.api.nvim_buf_get_name(self.buf)
							if file == '' or vim.fn.filereadable(file) == 0 then return Snacks.notify.warn { 'File not found!', file } end

							Snacks.picker.util.confirm('Delete this Scratch?', function()
								vim.api.nvim_buf_delete(self.buf, { force = true })
								if vim.fn.delete(file) then Snacks.notify.info 'File removed!' end
							end)
						end,
						desc = 'Delete Scratch File',
						mode = { 'i', 'n' },
					},
				},
			},
		},
	},
}
