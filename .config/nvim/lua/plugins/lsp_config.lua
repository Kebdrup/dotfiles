return {
	{
		"mason-org/mason.nvim",
		build = ":MasonUpdate",
		-- Mason prepends ~/.local/share/nvim/mason/bin to PATH at setup, which is
		-- how the hand-rolled server definitions in lsp/<name>.lua resolve their
		-- binaries. There is no nvim-lspconfig/mason-lspconfig here: all server
		-- definitions live in lsp/<name>.lua and are sourced by Neovim core.
		config = function(_, opts)
			require("mason").setup(opts)

			-- Native insert-mode completion + inlay hints (Neovim 0.12)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					vim.lsp.completion.enable(true, event.data.client_id, event.buf, { autotrigger = true })

					-- Inlay hints on by default in every buffer whose server supports
					-- them; <leader>th (config/keymaps.lua) is the per-buffer off-switch.
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
						vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
					end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				severity_sort = true,
				float = { source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			-- Server definitions live in lsp/<name>.lua on the runtimepath;
			-- Neovim 0.12 core sources them (:h lsp-config-runtime-package).
			vim.lsp.enable({ "ts_ls", "gopls", "basedpyright", "ruff", "eslint", "dartls" })
		end,
	},
}
