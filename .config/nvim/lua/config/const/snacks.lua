local M = {}

M.disabled_default_keys = {
	a = false,
	d = false,
	r = false,
	c = false,
	m = false,
	o = false,
	P = false,
	y = false,
	p = false,
	u = false,
	I = false,
	H = false,
	Z = false,
}
M.excludes = {
	'**/.git/*',
	'**/node_modules/*',
}

return M
