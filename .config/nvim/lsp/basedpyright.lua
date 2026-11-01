-- Ported from nvim-lspconfig (lsp/basedpyright.lua) — consumed as an rtp source by
-- Neovim 0.12 core (vim.lsp.config): :h lsp-config-runtime-package
--
-- Settings merged with the user's block: typeCheckingMode off, and inlay hints
-- pinned to call-argument names only (basedpyright defaults every other
-- inlayHints group to true, so they are explicitly disabled here).
--
-- Note: the user block previously set `basedpyright.typeCheckingMode`, which is
-- the deprecated name; the port uses `basedpyright.analysis.typeCheckingMode`.
-- https://docs.basedpyright.com/latest/configuration/language-server-settings/

local function set_python_path(command)
	local path = command.args
	local clients = vim.lsp.get_clients({
		bufnr = vim.api.nvim_get_current_buf(),
		name = "basedpyright",
	})
	for _, client in ipairs(clients) do
		if client.settings then
			---@diagnostic disable-next-line: param-type-mismatch
			client.settings.python = vim.tbl_deep_extend("force", client.settings.python or {}, { pythonPath = path })
		else
			client.config.settings = vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
		end
		client:notify("workspace/didChangeConfiguration", { settings = nil })
	end
end

---@type vim.lsp.Config
return {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = {
		"pyrightconfig.json",
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		".git",
	},
	settings = {
		basedpyright = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				-- https://docs.basedpyright.com/latest/configuration/language-server-settings/
				-- Explicitly setting `basedpyright.analysis.useLibraryCodeForTypes` is **discouraged** by the official docs.
				-- Because it will override per-project configurations like `pyproject.toml`.
				typeCheckingMode = "off",
				inlayHints = {
					callArgumentNames = true,
					variableTypes = false,
					functionReturnTypes = false,
					genericTypes = false,
				},
			},
			disableTaggedHints = true,
		},
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightOrganizeImports", function()
			local params = {
				command = "basedpyright.organizeimports",
				arguments = { vim.uri_from_bufnr(bufnr) },
			}

			-- Using client.request() directly because "basedpyright.organizeimports" is private
			-- (not advertised via capabilities), which client:exec_cmd() refuses to call.
			---@diagnostic disable-next-line: param-type-mismatch
			client.request("workspace/executeCommand", params, nil, bufnr)
		end, {
			desc = "Organize Imports",
		})

		vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightSetPythonPath", set_python_path, {
			desc = "Reconfigure basedpyright with the provided python path",
			nargs = 1,
			complete = "file",
		})
	end,
}
