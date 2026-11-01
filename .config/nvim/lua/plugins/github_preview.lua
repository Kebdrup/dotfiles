return {
	"wallpants/github-preview.nvim",
	cmd = { "GithubPreviewToggle" },
	opts = {
		theme = {
			name = "light",
			high_contrast = false,
		},
		scroll = {
			disable = true,
		},
		cursor_line = {
			disable = true,
		},
	},
	config = function(_, opts)
		require("github-preview").setup(opts)
	end,
}
