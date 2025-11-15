local M = {}

---@param file_or_buf? string|integer?
---@param opts? {no_prompt:boolean?, job_opts?: vim.fn.jobstart.Opts}
function M.delete(file_or_buf, opts)
	file_or_buf = file_or_buf or 0 ---@type string|integer? default to current buffer
	opts = opts or {}
	opts.job_opts = opts.job_opts or {}

	local file_path ---@type string
	local bufnr ---@type number?
	if type(file_or_buf) == 'number' then
		file_path = vim.api.nvim_buf_get_name(file_or_buf)
		bufnr = file_or_buf
	elseif type(file_or_buf) == 'string' then
		file_path = file_or_buf
		bufnr = require('util.buffer').get_buf_from_file(file_or_buf)
	else
		Snacks.notify.error { 'Buffer/file not found:', '**[' .. file_or_buf .. ']**' }
		return
	end

	if not file_path or file_path == '' then
		Snacks.notify.error 'Cannot delete unnamed buffer!'
		return
	end

	local rel_file_path = require('util.path').relative(file_path)
	local file_id = '**[' .. rel_file_path .. ']**'

	-- Confirmations
	if opts.no_prompt ~= true then
		local c = vim.fn.confirm
		-- stylua: ignore
		if c('Do want to delete ' .. rel_file_path .. '?', '&Yes\n&No', 2) ~= 1
			or (bufnr and vim.bo[bufnr].modified
			and c('This file is modified! Continue to delete ' .. rel_file_path .. '?', '&Yes\n&No', 2) ~= 1)
		then return end
	end

	Snacks.notify.info('Deleting ' .. file_id, { id = file_id })

	-- Close buffer before deleting file
	if bufnr then Snacks.bufdelete.delete(bufnr) end

	-- Delete file via cli
	vim.fn.jobstart(
		'trash put --debug ' .. vim.fn.shellescape(file_path),
		vim.tbl_extend('keep', {
			detach = true,
			on_exit = function(_, code)
				local success = code == 0
				local message = success and 'Successfully deleted' or 'Failed to delete'
				Snacks.notify({ message, file_id }, {
					level = success and 'info' or 'error',
					id = file_id,
				})
				pcall(opts.job_opts.on_exit or 0) ---@diagnostic disable-line: param-type-mismatch
			end,
		}, opts.job_opts)
	)
end

return M
