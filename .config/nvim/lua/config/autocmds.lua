local Augroup = Nihil.augroup
local Excludes = Nihil.config.exclude

local function setup_close_with_q(ev)
	local buf = ev.buf
	vim.bo[buf].buflisted = false

	vim.schedule(function()
		local function close_fn()
			vim.cmd 'close'
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
		vim.keymap.set('n', 'q', close_fn, { buffer = buf, silent = true, desc = 'Quit buffer' })
		vim.keymap.set('n', '<c-q>', close_fn, { buffer = buf, silent = true, desc = 'Quit buffer' })
	end)
end

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
	pattern = Excludes.filetypes,
	group = Augroup 'close_with_q_ft',
	callback = setup_close_with_q,
})
vim.api.nvim_create_autocmd('BufReadPost', {
	pattern = '*',
	group = Augroup 'close_with_q_bt',
	callback = function(ev)
		if vim.bo[ev.buf].bt ~= '' and Excludes.buffertypes_map[vim.bo[ev.buf].bt] then setup_close_with_q(ev) end
	end,
})

vim.api.nvim_create_autocmd('FileType', {
	group = Augroup 'strip_of_unneccessary_features',
	pattern = { 'json', 'jsonc', 'json5', 'markdown', 'mdx' },
	command = [[
		set conceallevel=0
		set nowrap
		set nospell
	]],
})

vim.api.nvim_create_autocmd('FileType', {
	group = Augroup 'plugin_ft_oil',
	pattern = 'oil',
	command = 'set signcolumn=yes:2',
})

vim.api.nvim_create_autocmd('FileType', {
	group = Augroup 'disable_folding',
	pattern = Excludes.filetypes,
	command = [[
		set nofoldenable
		set foldcolumn=0
	]],
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
	group = Augroup 'checktime',
	callback = function()
		if vim.o.buftype ~= 'nofile' then vim.cmd 'checktime' end
	end,
})

vim.api.nvim_create_autocmd('TermOpen', {
	group = Augroup 'term_startinsert',
	command = 'startinsert',
})

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
	group = Augroup 'last_loc',
	callback = function(ev)
		local buf = ev.buf
		local ft = vim.bo[buf].filetype
		if Excludes.filetypes_map[ft] or vim.b[buf].lazyvim_last_loc then return end

		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
	end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
	callback = function(event)
		local exclude = { 'gitcommit' }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then return end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
	end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd('BufWritePre', {
	group = Augroup 'auto_create_dir',
	callback = function(event)
		if event.match:match '^%w%w+:[\\/][\\/]' then return end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
	end,
})

vim.api.nvim_create_autocmd('BufDelete', {
	group = Augroup 'track_closed_buffers',
	callback = function(ev)
		local buf = ev.buf
		local bo = vim.bo[buf]
		local path = vim.api.nvim_buf_get_name(buf)

		local is_buffer_valid = vim.api.nvim_buf_is_valid(buf) and bo.modifiable and #path > 0 and not Excludes.filetypes_map[bo.filetype]
		if is_buffer_valid then Nihil.file.buf_history:store(path) end
	end,
})

vim.api.nvim_create_autocmd('DirChanged', {
	group = Augroup 'notify_dir_changed',
	callback = function()
		local cwd = vim.uv.cwd():gsub('^' .. vim.env.HOME, '~')
		Snacks.notify({ '**Changed Directory: [' .. cwd .. ']**' }, {
			id = 'autocmd__notify_dir_changed',
			timeout = 400,
		})
	end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd('VimResized', {
	group = Augroup 'resize_splits',
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd 'tabdo wincmd ='
		vim.cmd('tabnext ' .. current_tab)
	end,
})
