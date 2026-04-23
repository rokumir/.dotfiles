-- ANSI Escape Parsing
vim.api.nvim_create_autocmd("StdinReadPost", {
	pattern = "*",
	callback = function(ev)
		vim.opt_local.modifiable = true -- Ensure file is modifiable

		local buf = ev.buf
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		while #lines > 0 and vim.trim(lines[#lines]) == "" do
			lines[#lines] = nil
		end
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
		vim.api.nvim_chan_send(vim.api.nvim_open_term(buf, {}), table.concat(lines, "\r\n"))

		-- NOTE: set file unmodifiable
		vim.opt_local.modifiable = false -- Prevent accidental typing
		vim.opt_local.readonly = true
	end,
})
