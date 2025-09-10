return {
	'folke/snacks.nvim',
	keys = {
		{ '<leader>.', function() Snacks.scratch() end, desc = 'Scratch: Toggle Buffer' },
		{ '<leader>S', function() Snacks.scratch { ft = 'markdown', name = 'Todo' } end, desc = 'Scratch: Todo' },
		{ ';s.', function() Snacks.scratch.select() end, desc = 'Scratch: Select Buffer' },
	},
	---@type snacks.Config
	opts = {
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

							local choice = vim.fn.confirm('Delete this Scratch?', '&Yes\n&No', 2)
							if choice == 1 then
								vim.api.nvim_buf_delete(self.buf, { force = true })
								local success = vim.fn.delete(file)
								if success then Snacks.notify.info 'File removed!' end
							end
						end,
						desc = 'Delete Scratch File',
						mode = { 'i', 'n' },
					},
				},
			},
		},
	},
}
