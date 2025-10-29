---@diagnostic disable: missing-fields, return-type-mismatch
--- @module 'blink.cmp'
--- @type blink.cmp.Source
local M = {}

local cmp_items = {} ---@type blink.cmp.CompletionItem[]
local function get_todo_comments_cmp_items()
	if #cmp_items == 0 then
		local ok, tc = pcall(require, 'todo-comments.config')
		if not ok then return {} end

		for type, config in pairs(tc.options.keywords or {}) do
			local variants = vim.list_extend({ type }, config.alt or {})
			for _, variant in ipairs(variants) do
				---@type blink.cmp.CompletionItem
				local item = {
					label = variant,
					insertText = variant .. ': ',
					source_id = 'todo_comments',
					source_name = 'todo_comments',
					labelDetails = { description = ' ' .. type .. ' [todo]' },
					kind = vim.lsp.protocol.CompletionItemKind.Snippet,
					kind_hl = 'TodoFg' .. type,
					kind_icon = config.icon or '',
					kind_name = 'TodoComment' .. type,
					filterText = 'todo_' .. variant,
					sortText = 'todo_' .. type,
					insertTextMode = 2,
				}
				table.insert(cmp_items, item)
			end
		end
	end

	return cmp_items
end

function M.new() return setmetatable({}, { __index = M }) end

function M:get_completions(_, callback)
	local items = get_todo_comments_cmp_items()
	callback {
		items = items,
		is_incomplete_forward = true,
		is_incomplete_backward = false,
	}
	return function() end -- cancel function
end

return M
