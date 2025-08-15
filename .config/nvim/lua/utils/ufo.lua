---@module 'nvim-ufo'

local M = {}

local strwidth = vim.fn.strdisplaywidth

---@type MakeFoldHandler
M.default_opts = {
	icon = '󰁂', -- icon shown before the count
	pad_left = ' ', -- left padding around the suffix
	pad_right = '  ', -- right padding around the suffix
	hl = 'UfoFoldVirtText', -- single highlight group for the whole suffix
	fill_char = '', -- character used to fill the gap (e.g. '·', '•', '─', '…')
	fill_hl = 'UfoFoldVirtFillerText', -- optional highlight for the filler; nil keeps original text look
}

local function build_fill(width, ch, truncate)
	if width <= 0 then return '' end
	ch = (ch == nil or ch == '') and ' ' or ch
	local cw = strwidth(ch)
	if cw <= 0 then
		ch, cw = ' ', 1
	end
	if cw == 1 then return string.rep(ch, width) end
	local s = ch
	while strwidth(s) < width do
		s = s .. ch
	end
	if strwidth(s) > width then s = truncate(s, width) end
	return s
end

-- A small, configurable factory so you can tweak visuals without touching logic.
---@param opts MakeFoldHandler
---@return UfoFoldVirtTextHandler
function M.make_fold_handler(opts)
	opts = vim.tbl_deep_extend('force', {}, M.default_opts, opts or {})

	---@type UfoFoldVirtTextHandler
	return function(virtText, lnum, endLnum, width, truncate)
		local new = {}

		-- Build suffix once; keep it a single chunk so styling is easy to change.
		local count = endLnum - lnum
		local suffix = string.format('%s%s %d%s', opts.pad_left, opts.icon, count, opts.pad_right)
		local suf_w = strwidth(suffix)
		local target = width - suf_w

		-- If the suffix alone is wider than the available width, show as much as we can.
		if target <= 0 then return { { truncate(suffix, width), opts.hl } } end

		-- Fill the left side with original text until we run out of space.
		local cur = 0
		for _, chunk in ipairs(virtText) do
			local text, hl = chunk[1], chunk[2]
			local w = strwidth(text)
			if cur + w < target then
				table.insert(new, chunk)
				cur = cur + w
			else
				local truncated = truncate(text, target - cur)
				table.insert(new, { truncated, hl })
				cur = cur + strwidth(truncated)
				break
			end
		end

		-- Add filler to reach target width, then append the suffix.
		if cur < target then
			local filler = build_fill(target - cur - 1, opts.fill_char, truncate)
			filler = ' ' .. filler -- add left padding
			table.insert(new, { filler, opts.fill_hl })
		end

		table.insert(new, { suffix, opts.hl })
		return new
	end
end

return M

---@class MakeFoldHandler
---@field icon string? Icon shown before the count
---@field pad_left string? Left padding around the suffix
---@field pad_right string? Right padding around the suffix
---@field hl string? Single highlight group for the whole suffix
---@field fill_char string? Character used to fill the gap (e.g. '·', '•', '─', '…')
---@field fill_hl string? Highlight for the filler; nil keeps original text look
