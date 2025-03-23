local map = require('utils.keymap').map
local function augroup(name, opts) return vim.api.nvim_create_augroup('nihil_' .. name, opts or { clear = true }) end

local ignored_filetypes = {
	notify = true, -- LazyVim notifications
	noice = true, -- Noice UI
	mason = true,
	lazy = true,
	TelescopePrompt = true,
	NvimTree = true,
	['neo-tree'] = true,
	dashboard = true,
	alpha = true,
	DressingInput = true,
	DressingSelect = true,
	qf = true, -- Quickfix
}

-- Settings for the greatest script of all time
vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'simple_window',
	pattern = 'tmux-harpoon', -- in config.filetype
	callback = function(e)
		vim.opt.showmode = false
		vim.opt.ruler = false
		vim.opt.laststatus = 0
		vim.opt.showcmd = false
		vim.opt.wrap = false

		map { 'n', '<c-q>', '<cmd>quit <cr>', buffer = e.buf }
		map { 'n', '<c-s>', '<cmd>write | quit <cr>', buffer = e.buf }
	end,
})

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd('InsertLeave', {
	group = augroup 'no_paste',
	pattern = '*',
	command = 'set nopaste',
})

vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'concealment',
	pattern = { 'json', 'jsonc', 'markdown' },
	callback = function() vim.opt.wrap = false end,
})

-- Advanced LSP progress
vim.api.nvim_create_autocmd('LspProgress', {
	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
	callback = function(ev)
		local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
		vim.notify(vim.lsp.status(), 'info', {
			id = 'lsp_progress',
			title = 'LSP Progress',
			opts = function(notif)
				notif.icon = ev.data.params.value.kind == 'end' and ' ' or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})

-- -- Function to check and disable diagnostics based on modeline in the first 3 lines
-- -- Create an autocommand to run the function when a buffer is read or entered
-- vim.api.nvim_create_autocmd({ 'FileType', 'BufRead', 'BufEnter' }, {
-- 	group = augroup 'disable_diagnostics_comment',
-- 	pattern = { 'typescript', 'typescriptreact' },
-- 	callback = function()
-- 		local bufnr = vim.api.nvim_get_current_buf()
-- 		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 3, false)
-- 		if not lines or #lines == 0 then
-- 			return -- Buffer is empty
-- 		end
--
-- 		-- Get the comment string for the current filetype
-- 		local comment_string = vim.bo[bufnr].commentstring:match '^(.-)%%s'
-- 		if not comment_string then return end -- No valid comment string found
--
-- 		-- Build a Lua pattern to match the modeline
-- 		-- Allows for flexible whitespace between the comment and the directive
-- 		local pattern = string.format('^%s%s%s$', comment_string, '%s+', 'vim:diagnostics%s*disable')
--
-- 		for _, line in ipairs(lines) do
-- 			if line:match(pattern) then
-- 				vim.diagnostic.enable(false, { bufnr = bufnr })
-- 				Snacks.notify.info '-------Match-------'
-- 				return
-- 			end
-- 		end
-- 	end,
-- })

-- Automatically rename tmux window to the current buffer's filename
-- vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost', 'BufNewFile' }, {
-- 	group = augroup 'auto_rename_tmux_with_nvim_buffer_name',
-- 	callback = function()
-- 		local filename = vim.fn.expand '%'
-- 		vim.fn.system('tmux rename-window ' .. filename)
-- 	end,
-- })

--#region Update tmux pane title with nvim current file loc
if vim.g.nihil_autocmd_tmux_pane_title_update then
	-- Function to reset tmux title when leaving nvim
	local function reset_tmux_title()
		vim.fn.system 'tmux set-option -p @nvim_title ""'
		vim.g.tmux_title_cache = ''
	end

	-- Helper function to check if buffer is a "real" file we care about
	local function is_real_buffer()
		local buftype = vim.bo.buftype
		-- Ignore terminal, help, quickfix, nofile, etc.
		if buftype ~= '' or buftype == 'nofile' then return false end

		local buf_name = vim.fn.expand '%'
		if ignored_filetypes[vim.bo.filetype] then return false end

		-- Skip temporary files or special paths
		local bad_buf = buf_name:match '^%s*$' -- Empty buffer name
			or buf_name:match '^term://' -- Terminal
			or buf_name:match '^oil://' -- Oil.nvim

		return not bad_buf
	end

	-- Update title on buffer events
	vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
		group = augroup 'update_tmux_title__on_file_changes',
		callback = function()
			-- Only proceed for real buffers we care about
			if not is_real_buffer() then return end

			local buf_path = vim.fn.expand '%'
			local new_title = ''

			-- Create new title
			if buf_path ~= '' then new_title = '·' .. vim.fn.fnamemodify(buf_path, ':~:.') end

			-- Only update if title has changed
			if new_title ~= vim.g.tmux_title_cache then
				vim.g.tmux_title_cache = new_title -- Update the cache in global var
				vim.fn.system('tmux set-option -p @nvim_title "' .. new_title .. '"')
			end
		end,
	})
	-- Reset title when leaving nvim
	vim.api.nvim_create_autocmd('VimLeavePre', {
		group = augroup 'reset_tmux_title__on_leave',
		callback = reset_tmux_title,
	})

	-- Handle empty buffer case with debounce check
	vim.api.nvim_create_autocmd({ 'BufDelete' }, {
		group = augroup 'reset_tmux_title__on_buf_del',
		callback = function()
			-- Use vim.schedule to slightly delay this check
			vim.schedule(function()
				local listed_buffers = vim.fn.getbufinfo { buflisted = 1 }
				if #listed_buffers == 0 then
					reset_tmux_title()
				else
					-- Check if we should update title after deletion
					-- This handles cases where focus moves to another buffer
					local current_buf = vim.api.nvim_get_current_buf()
					if is_real_buffer() then
						-- Force re-trigger BufEnter for current buffer
						vim.cmd 'doautocmd BufEnter'
					else
						-- Current buffer is not a real file, clear title
						reset_tmux_title()
					end
				end
			end)
		end,
	})
end
--#endregion
