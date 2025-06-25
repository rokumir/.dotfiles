local M = {}

---@return VSCode?
function M.get()
	local success, vscode = pcall(require, 'vscode')
	return success and vscode or nil
end

return M

---@class VSCode
---@field enabled? boolean
---@field action fun(name: string, opts?: VSCode.ActionOpts): any  Asynchronously executes a vscode command.
---@field call fun(name: string, opts?: VSCode.ActionOpts, timeout?: number): any  Synchronously executes a vscode command.
---@field eval fun(code: string, opts?: VSCode.Opts, timeout?: number): any  Evaluate javascript synchronously in vscode and return the result
---@field eval_async fun(code: string, opts?: VSCode.Opts): any  Evaluate javascript asynchronously in vscode
---@field notify fun(msg: string): any  Shows a vscode message (see also Nvim's vim.notify).
---@field on fun(event:any,callback:any): any  [DEPRECATED] Defines a handler for some Nvim UI events.
---@field to_op fun(callback: fun(ctx): any): any  A helper for map-operator. See code_actions.lua for the usage
---@field with_insert fun(callback: function, ms?: number): any  Perform operations in insert mode.
---@field get_config fun(name: string|string[]): any  Gets a vscode setting value.
---@field has_config fun(name: string|string[]): any  Checks if a vscode setting exists.
---@field update_config fun(name: string|string[], value:any|any[], target?:'global'|'workspace'|'workspace_folder'|string): any  Sets a vscode setting.

---@class VSCode.ActionOpts : VSCode.Opts
---@field range table Specific range for the action (all values are 0-indexed): \[start_line,end_line\] │ \[start_line,start_char,end_line,end_char\] │ {start={line=start_line,character=start_char},end={line=end_line,character=end_char}}
---@field restore_selection boolean Whether to preserve the current selection. Only valid when range is specified. Defaults to `true`.
---@field callback fun(err:string|nil,ret):any Function to handle the action result.

---@class VSCode.Opts
---@field args table List of arguments passed to the vscode command. If the command only requires a single object parameter, you can directly pass in a map-like table.
