local biome = { 'biome', 'prettier', 'prettierd' }

local web_dev_formatters_by_ft = {} ---@type table<string, table>
for _, ft in ipairs {
	'typescript',
	'typescriptreact',
	'javascript',
	'javascriptreact',
	'markdown',
	'css',
	'scss',
	'sass',
	'json',
	'jsonc',
	'astro',
	'less',
	'yaml',
	'svelte',
	'vue',
	'angular',
} do
	web_dev_formatters_by_ft[ft] = biome
end

return {
	{
		'stevearc/conform.nvim',
		opts = {
			log_level = vim.log.levels.WARN,
			notify_on_error = false,
			notify_no_formatters = true,
			formatters_by_ft = vim.tbl_deep_extend('force', {}, web_dev_formatters_by_ft, {}),
		},
	},
}
