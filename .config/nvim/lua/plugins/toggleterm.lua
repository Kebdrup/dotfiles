return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({})
		vim.keymap.set("n", "<leader>to", "<CMD>2ToggleTerm direction=float<CR>", { desc = "Open floating terminal" })
		vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { desc = "Open floating terminal" })

		-- Create a custom open code terminal
		local Terminal = require("toggleterm.terminal").Terminal
		local opencode = Terminal:new({
			cmd = "opencode",
			hidden = true,
			direction = "vertical",
			on_open = function(term)
				vim.cmd("wincmd H")
				vim.api.nvim_win_set_width(0, 121)
				vim.defer_fn(function()
					vim.api.nvim_win_set_width(0, 120)
					print("resized")
				end, 500) -- 50ms delay; adjust as needed
			end,
		})
		function opencode_toggle()
			opencode:toggle(120)
		end
		vim.api.nvim_set_keymap("n", "<leader>ac", "<cmd>lua opencode_toggle()<CR>", { noremap = true, silent = true })
	end,
}
