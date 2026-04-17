-- ANSI Escape Parsing
vim.api.nvim_create_autocmd("StdinReadPost", {
	pattern = "*",
	once = true,
	callback = function(ev)
		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.wo.statuscolumn = ""
		vim.wo.signcolumn = "no"
		vim.opt.listchars = { space = " " }

		local buf = ev.buf

		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		while #lines > 0 and vim.trim(lines[#lines]) == "" do
			lines[#lines] = nil
		end
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

		vim.b[buf].minianimate_disable = true

		vim.api.nvim_chan_send(vim.api.nvim_open_term(buf, {}), table.concat(lines, "\r\n"))
		vim.api.nvim_create_autocmd("TextChanged", { once = true, buffer = buf, command = "normal! G$" })
		vim.api.nvim_create_autocmd("TermEnter", { once = true, buffer = buf, command = "stopinsert" })
		vim.api.nvim_create_autocmd("BufModifiedSet", { once = true, buffer = buf, command = "normal! 1G^" })

		vim.defer_fn(function()
			vim.b[buf].minianimate_disable = false
		end, 2000)
	end,
})
