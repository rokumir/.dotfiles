---@class Nihil : NihilUtil
---@field config NihilConfig

---@type Nihil
local M = vim.tbl_deep_extend('force', {}, require 'nihil.util', { config = require 'nihil.config' })

return M
