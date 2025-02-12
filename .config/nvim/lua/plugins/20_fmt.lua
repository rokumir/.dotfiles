local web_dev_formatter_opts = {
	'biome',
	'prettierd',
	lsp_format = 'prefer', -- fallback behavior
	quiet = true,
}
local web_dev_lang = {
	'typescript',
	'typescriptreact',
	'javascript',
	'javascriptreact',
	'json',
	'jsonc',

	'markdown',
	'astro',
	'vue',
}

local exception_lang_formatter_opts = { 'prettierd' }
local exception_lang = {
	'css',
	'scss',
	'sass',
	'svelte',
	'angular',
	'less',
	'yaml',
}

local formatters_by_ft = {} ---@type table<string, table>
for _, ft in ipairs(web_dev_lang) do
	formatters_by_ft[ft] = web_dev_formatter_opts
end
for _, ft in ipairs(exception_lang) do
	formatters_by_ft[ft] = exception_lang_formatter_opts
end

return {
	{
		'stevearc/conform.nvim',
		opts = {
			log_level = vim.log.levels.WARN,
			formatters_by_ft = formatters_by_ft,
		},
	},
}
