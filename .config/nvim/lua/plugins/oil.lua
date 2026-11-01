return {
	"stevearc/oil.nvim",
	opts = {},
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	config = function()
		require("oil").setup({
			view_options = {
				show_hidden = true,
			},
			keymaps = {
				["<C-h>"] = { "actions.select", opts = { horizontal = true } },
				["<C-v>"] = { "actions.select", opts = { vertical = true } },
				["<C-l>"] = false,
				["<C-r>"] = "actions.refresh",
			},
		})
	end,
}
