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
			local title = success and 'Opened in Obsidian' or 'Failed to open Obsidian URL'
			vim.schedule(function()
				Snacks.notify[action]({
					'Vault: ' .. vault_name,
					'File: ' .. relative_file,
				}, { title = title })
			end)
		end,
	})
end

return M
