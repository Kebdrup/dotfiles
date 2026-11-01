return {
	-- Full rewrite; does not support lazy-loading
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({
			"c",
			"lua",
			"vim",
			"vimdoc",
			"javascript",
			"html",
			"typescript",
			"python",
			"tsx",
			"go",
		})

		-- The tsx parser serves the typescriptreact filetype
		vim.treesitter.language.register("tsx", "typescriptreact")

		-- Highlighting is provided by Neovim core; enable it per filetype
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "c", "lua", "vim", "vimdoc", "javascript", "html", "typescript", "typescriptreact", "python", "go" },
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})

		vim.api.nvim_set_hl(0, "tsxCloseString", { link = "htmlTag" }) -- Fix green closing tags
	end,
}
