local M = {}

M.format = {}

--- Convert input into a timestamp:
---@param t? number|table|osdate|string
--- - nil -> now - number -> timestamp as-is
--- - table -> os.time(table)
local function to_timestamp(t)
	local ty = type(t)
	if ty == 'nil' then
		return os.time()
	elseif ty == 'number' then
		return t
	elseif ty == 'table' then
		return os.time(t)
	else
		error('Invalid date value: expected table|number|nil, got ' .. ty)
	end
end

--- Get ordinal suffix (1 -> "1st", 2 -> "2nd", etc.)
---@param n number|string
---@return string|nil
local function ordinal(n)
	n = tonumber(n) or error 'Invalid param'
	if not n then return nil end
	n = math.floor(math.abs(n))
	local rem100 = n % 100
	if rem100 >= 11 and rem100 <= 13 then return tostring(n) .. 'th' end
	local rem10 = n % 10
	if rem10 == 1 then
		return tostring(n) .. 'st'
	elseif rem10 == 2 then
		return tostring(n) .. 'nd'
	elseif rem10 == 3 then
		return tostring(n) .. 'rd'
	else
		return tostring(n) .. 'th'
	end
end

--- Mon, Aug 4th (defaults); configurable via opts
---@param t? table|number
---@param opts? PrettyDateOpts
---@return string
function M.format.pretty_date(t, opts)
	opts = vim.tbl_deep_extend('force', {
		weekday = 'short',
		month = 'short',
		use_ordinal = true,
	}, opts or {})

	local ts = to_timestamp(t)
	local wfmt = opts.weekday == 'long' and '%A' or '%a'
	local mfmt = opts.month == 'long' and '%B' or '%b'
	local weekday = opts.weekday and os.date(wfmt, ts) or nil
	local month = os.date(mfmt, ts)

	local dayn = tonumber(os.date('%d', ts)) or error '`dayn` is not a number'
	local day = opts.use_ordinal and (ordinal(dayn) or tostring(dayn)) or tostring(dayn)

	if weekday then
		return string.format('%s, %s %s', weekday, month, day)
	else
		return string.format('%s %s', month, day)
	end
end

--- 3:35 PM (defaults); configurable via opts
---@param t? table|number
---@param opts? PrettyTimeOpts
---@return string
function M.format.pretty_time(t, opts)
	opts = vim.tbl_deep_extend('force', {
		hour12 = true,
		pad_hour = false,
		show_seconds = false,
		ampm_upper = true,
	}, opts or {})

	local ts = to_timestamp(t)
	local H = tonumber(os.date('%H', ts))
	local MM = os.date('%M', ts)
	local SS = os.date('%S', ts)

	if opts.hour12 then
		local am = H < 12
		local h = H % 12
		if h == 0 then h = 12 end
		local hour = opts.pad_hour and string.format('%02d', h) or tostring(h)
		local ampm = am and 'am' or 'pm'
		if opts.ampm_upper then ampm = string.upper(ampm) end
		if opts.show_seconds then
			return string.format('%s:%s:%s %s', hour, MM, SS, ampm)
		else
			return string.format('%s:%s %s', hour, MM, ampm)
		end
	else
		local hour = opts.pad_hour and string.format('%02d', H) or tostring(H)
		if opts.show_seconds then
			return string.format('%s:%s:%s', hour, MM, SS)
		else
			return string.format('%s:%s', hour, MM)
		end
	end
end

--- Mon, Aug 4th 3:35 PM (defaults)
---@param t? table|number
---@param opts? PrettyOpts
---@return string
function M.format.pretty(t, opts)
	local ts = to_timestamp(t)
	opts = opts or {}
	local date = M.format.prettify_date(ts, opts.date)
	local time = M.format.prettify_time(ts, opts.time)
	return date .. ' ' .. time
end

return M

-- -------
---@class PrettyDateOpts
---@field weekday? 'short'|'long'|false include weekday or false to omit
---@field month? 'short'|'long' month name style
---@field use_ordinal? boolean append st/nd/rd/th

---@class PrettyTimeOpts
---@field hour12? boolean 12-hour if true, 24-hour if false
---@field pad_hour? boolean left-pad hour with 0
---@field show_seconds? boolean include :ss
---@field ampm_upper? boolean AM/PM upper-case

---@class PrettyOpts
---@field date? PrettyDateOpts
---@field time? PrettyTimeOpts
