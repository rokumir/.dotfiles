local function deno_fmt(ft)
	return {
		'deno_fmt',
		args = { '--ext', ft, '--stdin-filepath', '$FILENAME', '--unstable-component' },
	}
end
local biome = { 'biome' }

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
			formatters_by_ft = web_dev_formatters_by_ft,
		},
	},
}
