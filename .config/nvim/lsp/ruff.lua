-- Ported from nvim-lspconfig (lsp/ruff.lua) — consumed as an rtp source by
-- Neovim 0.12 core (vim.lsp.config): :h lsp-config-runtime-package
--
-- Server settings can be provided via:
--   vim.lsp.config('ruff', { init_options = { settings = { ... } } })
-- Refer to https://docs.astral.sh/ruff/editors/ for more details.

---@type vim.lsp.Config
return {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
	settings = {},
}
