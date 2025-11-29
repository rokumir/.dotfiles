---@class NihilUtil : NihilUtilMisc
local M = {}

M.datetime = require 'nihil.util.datetime'
M.file = require 'nihil.util.file'
M.keymap = require 'nihil.util.keymap'
M.markdown = require 'nihil.util.markdown'
M.path = require 'nihil.util.path'
M.table = require 'nihil.util.table'
M.misc = require 'nihil.util.misc'

for k, v in pairs(require 'nihil.util.misc') do
	M[k] = v
end

return M
