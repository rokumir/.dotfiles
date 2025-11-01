local M = {}

---@param file_or_buf? string|integer?
---@param opts? vim.fn.jobstart.Opts|{no_prompt:boolean?}
function M.delete(file_or_buf, opts)
	opts = opts or {}
	file_or_buf = file_or_buf or 0 ---@type string|integer? default to current buffer

	local file_path = type(file_or_buf) == 'number' and vim.api.nvim_buf_get_name(file_or_buf) or file_or_buf ---@cast file_path string
	local bufnr = type(file_or_buf) == 'string' and require('util.buffer').get_buf_from_file(file_or_buf) or file_or_buf ---@cast bufnr number?

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
	local cmd = 'trash put --debug ' .. vim.fn.shellescape(file_path)
	local job_opts = vim.tbl_extend('keep', {
		detach = true,
		on_exit = function(_, code)
			local success = code == 0
			local message = success and 'Successfully deleted' or 'Failed to delete'
			Snacks.notify({ message, file_id }, {
				level = success and 'info' or 'error',
				id = file_id,
			})
			pcall(opts.on_exit or 0) ---@diagnostic disable-line: param-type-mismatch
		end,
	}, opts)
	vim.fn.jobstart(cmd, job_opts)
end

return M
