-- Ported from nvim-lspconfig (lsp/dartls.lua) — consumed as an rtp source by
-- Neovim 0.12 core (vim.lsp.config): :h lsp-config-runtime-package
--
-- Language server for dart.
-- https://github.com/dart-lang/sdk/tree/master/pkg/analysis_server/tool/lsp_spec

---@type vim.lsp.Config
return {
	cmd = { "dart", "language-server", "--protocol=lsp" },
	filetypes = { "dart" },
	root_markers = { "pubspec.yaml" },
	init_options = {
		onlyAnalyzeProjectsWithOpenFiles = true,
		suggestFromUnimportedLibraries = true,
		closingLabels = true,
		outline = true,
		flutterOutline = true,
	},
	settings = {
		dart = {
			completeFunctionCalls = true,
			showTodos = true,
		},
	},
}
