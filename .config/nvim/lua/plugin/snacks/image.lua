return {
	'folke/snacks.nvim',
	---@module 'snacks'
	---@type snacks.Config
	opts = {
		image = {
			enabled = true,
			force = true, -- try displaying the image, even if the terminal does not support it

			preferred_protocol = 'wezterm', -- or "kitty"
			fallback_protocol = 'chafa',
			inline_in_docs = true,
			max_width = 80,
			max_height = 40,

			cache = vim.fn.stdpath 'cache' .. '/snacks/image',
			icons = { math = '󰪚 ', chart = '󰄧 ', image = ' ' },
			debug = { request = false, convert = false, placement = false },
			env = {},

			math = { enabled = true },

			img_dirs = { 'img', 'images', 'assets', 'static', 'public', 'media', 'attachments', '__assets', 'banners' },
			formats = {
				'png',
				'jpg',
				'jpeg',
				'gif',
				'bmp',
				'webp',
				'tiff',
				'heic',
				'avif',
				'mp4',
				'mov',
				'avi',
				'mkv',
				'webm',
				'pdf',
			},

			doc = {
				enabled = true,
				inline = true,
				float = true,
				max_width = 80,
				max_height = 40,
			},

			-- window options applied to windows displaying image buffers
			-- an image buffer is a buffer with `filetype=image`
			wo = {
				wrap = false,
				number = false,
				relativenumber = false,
				cursorcolumn = false,
				signcolumn = 'no',
				foldcolumn = '0',
				list = false,
				spell = false,
				statuscolumn = '',
			},

			convert = { notify = true }, -- show a notification on error
		},
	},
}
