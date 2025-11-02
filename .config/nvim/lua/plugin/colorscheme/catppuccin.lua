return {
	'catppuccin/nvim',
	enabled = false,
	name = 'catppuccin',
	priority = 1000,
	opts = {
		flavour = 'mocha', -- latte, frappe, macchiato, mocha
		transparent_background = true,
		term_colors = true,
		styles = {
			comments = { 'italic' },
			conditionals = { 'italic' },
			types = { 'bold' },
		},
	},
}
