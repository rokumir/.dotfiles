---@param bufnr number
---@param ... string
local function first_formatter(bufnr, ...)
	local conform = require 'conform'
	for i = 1, select('#', ...) do
		local formatter = select(i, ...)
		local formatter_info = conform.get_formatter_info(formatter, bufnr)
		if formatter_info.available then return formatter end
	end
	return select(1, ...)
end
---@param formatters string[]
local function extract_first_formatter(formatters)
	return function(bufnr) return { first_formatter(bufnr, unpack(formatters)) } end
end

return {
	{
		'stevearc/conform.nvim',
		---@param opts conform.setupOpts
		opts = function(_, opts)
			local conform_utils = require 'conform.util'

			opts.log_level = vim.log.levels.WARN

			--#region Web Dev formatters config
			for _, ft in ipairs {
				'typescript',
				'typescriptreact',
				'javascript',
				'javascriptreact',
				'astro',
				'yaml',
				'json',
				'jsonc',
				'css',
				'scss',
				'sass',
			} do
				opts.formatters_by_ft[ft] = extract_first_formatter { 'biome', 'prettier', 'prettierd' }
			end

			-- not widely supported
			-- for _, ft in ipairs { 'markdown', 'svelte', 'angular', 'vue', } do
			-- 	opts.formatters_by_ft[ft] = { 'prettier' }
			-- end

			opts.formatters.biome = {
				cwd = conform_utils.root_file { 'biome.json', 'biome.jsonc' },
				require_cwd = true,
			}
			opts.formatters.prettier = {
				cwd = conform_utils.root_file {
					'.prettierrc',
					'.prettierrc.json',
					'.prettierrc.yml',
					'.prettierrc.yaml',
					'.prettierrc.json5',
					'.prettierrc.js',
					'.prettierrc.cjs',
					'.prettierrc.mjs',
					'.prettierrc.toml',
					'prettier.config.js',
					'prettier.config.cjs',
					'prettier.config.mjs',
				},
				require_cwd = false,
			}
			--#endregion Web Dev formatters config
		end,
	},
}

--[[
Use primary `biome` in web dev projects (has package.json or biome.json in the project)
Except when there is prettier configured in the project

]]

---@module 'conform'
