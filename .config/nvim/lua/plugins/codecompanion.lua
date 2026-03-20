return {
	"olimorris/codecompanion.nvim",
	opts = {
		strategies = {
			chat = {
				name = "copilot",
				model = "claude-sonnet-4.5",
			},
			inline = {
				name = "copilot",
			},
			agent = {
				name = "copilot",
			},
		},
		-- NOTE: The log_level is in `opts.opts`
		opts = {
			log_level = "DEBUG",
		},
	},
	keys = {
		{
			"<leader>ac", -- Open CodeCompanion chat
			"<cmd>CodeCompanionChat<CR>",
			desc = "Open CodeCompanion Chat",
		},
		{
			"<leader>ar", -- Run code review
			"<cmd>CodeCompanionReview<CR>",
			desc = "CodeCompanion Review Selected Code",
			mode = { "v" },
		},
		{
			"<leader>at", -- Generate tests
			"<cmd>CodeCompanionTest<CR>",
			desc = "CodeCompanion Generate Tests",
			mode = { "v" },
		},
		{
			"<leader>af", -- Propose fixes for selected code
			"<cmd>CodeCompanionFix<CR>",
			desc = "CodeCompanion Propose Fixes",
			mode = { "v" },
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}
