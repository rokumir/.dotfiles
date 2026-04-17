vim.api.nvim_create_autocmd("StdinReadPost", {
	pattern = "*",
	once = true,
	callback = function()
		vim.opt_local.modifiable = false -- Prevent accidental typing
		vim.opt_local.readonly = true
	end,
})
