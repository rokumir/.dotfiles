---@diagnostic disable: undefined-field, return-type-mismatch, missing-fields, redefined-local, unused-local
local kind_icon_type = {
	FIX = '',
	TEST = '',
	WARN = '',
	PERF = '',
	NOTE = '',
	TODO = '',
	HACK = '',
}

local ok, tc = pcall(require, 'todo-comments.config')
local keywords = ok and tc.keywords or {}
local cmp_items = require('utils.table').map(keywords, function(variant, type)
	---@type blink.cmp.CompletionItem
	return {
		label = variant .. '  [todo]',
		insertText = variant .. ': ',
		kind = vim.lsp.protocol.CompletionItemKind.Snippet,
		kind_hl = 'TodoFg' .. type,
		kind_icon = kind_icon_type[type] or '',
		kind_name = 'TodoComment' .. type,
		labelDetails = { description = type },
		source_name = 'todo_comments',
	}
end)

--- @module 'blink.cmp'
--- @type blink.cmp.Source
local M = {}

function M.new() return setmetatable({}, { __index = M }) end

function M:get_completions(ctx, callback)
	local transformed_callback = function(items)
		callback {
			context = ctx,
			is_incomplete_forward = false,
			is_incomplete_backward = false,
			items = items,
		}
	end

	if ctx.get_keyword():lower():match '^tod' then return transformed_callback {} end

	transformed_callback(cmp_items)

	return function() end
end

return M
