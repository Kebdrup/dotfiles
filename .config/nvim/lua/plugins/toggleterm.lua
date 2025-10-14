return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({})
		vim.keymap.set("n", "<leader>to", "<CMD>ToggleTerm direction=float<CR>", { desc = "Open floating terminal" })
		vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { desc = "Open floating terminal" })
	end,
}
