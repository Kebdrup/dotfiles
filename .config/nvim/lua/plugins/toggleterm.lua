return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({})
		vim.keymap.set("n", "<leader>to", "<CMD>ToggleTerm direction=float<CR>", { desc = "Open floating terminal" })
		vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { desc = "Open floating terminal" })

		-- Create a custom open code terminal
		local Terminal = require("toggleterm.terminal").Terminal
		local opencode = Terminal:new({
			cmd = "opencode",
			hidden = true,
			direction = "vertical",
			on_open = function(term)
				vim.cmd("wincmd H")
				vim.api.nvim_win_set_width(0, 120)
			end,
		})
		function opencode_toggle()
			opencode:toggle(80)
		end
		vim.api.nvim_set_keymap("n", "<leader>c", "<cmd>lua opencode_toggle()<CR>", { noremap = true, silent = true })
	end,
}
