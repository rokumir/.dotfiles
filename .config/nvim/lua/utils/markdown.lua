local M = {}

function M.open_current_buffer_in_obsidian()
	local file = vim.api.nvim_buf_get_name(0)
	if file == '' then error('Buffer has no name', 2) end
	local pwd = vim.fn.getcwd()
	local vault_name = vim.fn.fnamemodify(pwd, ':t')
	local relative_file = file:gsub('^' .. pwd .. '/', '')
	local obsidian_url = 'obsidian://open?vault=' .. vault_name .. '&file=' .. relative_file
	vim.fn.jobstart({ 'xdg-open', obsidian_url }, {
		detach = true,
		on_exit = function(_, return_val)
			local success = return_val == 0
			local action = success and 'info' or 'error'
			local message = success and 'Opened in Obsidian:' or 'Failed to open Obsidian URL:'
			vim.schedule(function() Snacks.notify[action](message .. ' ' .. obsidian_url, vim.log.levels[action]) end)
		end,
		on_stderr = function(_, data)
			if data then vim.schedule(function() Snacks.notify.error('Error opening Obsidian URL: ' .. table.concat(data, ' ')) end) end
		end,
	})
end

return M
