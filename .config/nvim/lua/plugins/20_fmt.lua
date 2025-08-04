---@module 'conform'

local function formater_fallbacks(formatters)
	return function(bufnr)
		local conform = require 'conform'
		for _, formatter in ipairs(formatters) do
			local info = conform.get_formatter_info(formatter, bufnr)
			if info.available then return { formatter } end
		end
		return { formatters[1] }
	end
end

return {
	{
		'stevearc/conform.nvim',
		---@type conform.setupOpts
		opts = {
			log_level = vim.log.levels.WARN,
			formatters_by_ft = {
				dataviewjs = { 'prettier' },
			},
		},
	},

	{
		'stevearc/conform.nvim',
		---@param opts conform.setupOpts
		opts = function(_, opts)
			for _, ft in ipairs {
				'typescript',
				'typescriptreact',
				'javascript',
				'javascriptreact',
				'json',
				'jsonc',
				'css',
				'graphql',
				'gritql',
			} do
				opts.formatters_by_ft[ft] = formater_fallbacks { 'biome', 'prettier', 'prettierd' }
			end
		end,
	},
}
