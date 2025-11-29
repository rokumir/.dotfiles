---@diagnostic disable: missing-fields, return-type-mismatch
--- @module 'blink.cmp'
--- @type blink.cmp.Source
local M = {}

function M.new() return setmetatable({}, { __index = M }) end

function M:get_completions(_, callback)
	local items = require('nihil.plugin.todo-comments.util').get_todo_comments_cmp_items()
	callback {
		items = items,
		is_incomplete_forward = true,
		is_incomplete_backward = false,
	}
	return function() end -- cancel function
end

return M
