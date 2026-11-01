-- All user keymaps live in this file.
-- Mappings that reference a plugin resolve it inside the function body,
-- so lazy.nvim loads the plugin on the first keypress.

-- Tag navigation
vim.keymap.set("n", "]]", "<C-]>", { desc = "Jump to tag" })
vim.keymap.set("n", "[[", "<CMD>pop<CR>", { desc = "Go back a tag" })
vim.keymap.set("n", "<Leader>k", "<C-]>", { desc = "Jump to tag" })
vim.keymap.set("n", "<Leader>j", "<CMD>pop<CR>", { desc = "Go back a tag" })

-- Oil
vim.keymap.set("n", "<C-o>", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

-- Clear highlights
vim.keymap.set("n", "<tab>", "<CMD>nohl<CR>", { desc = "Clear highlights" })

-- LSP (global)
vim.keymap.set("n", "<C-.>", vim.lsp.buf.code_action, { desc = "Show code actions" })
vim.keymap.set("n", "<C-,>", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
vim.keymap.set("n", "<Leader>r", vim.lsp.buf.rename, { desc = "Rename across files" })
vim.keymap.set("n", "K", function()
	vim.lsp.buf.hover({ border = "single", max_height = 25, max_width = 120 })
end)

-- LSP (buffer-local, set on attach)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-keymaps", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("<leader>gr", function()
			require("telescope.builtin").lsp_references()
		end, "[G]oto [R]eferences")
		map("<leader>gi", function()
			require("telescope.builtin").lsp_implementations()
		end, "[G]oto [I]mplementation")
		map("<leader>gd", function()
			require("telescope.builtin").lsp_definitions()
		end, "[G]oto [D]efinition")
		map("<leader>gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		map("<leader>gt", function()
			require("telescope.builtin").lsp_type_definitions()
		end, "[G]oto [T]ype Definition")

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		-- Highlight references of the word under the cursor while it rests there
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
			local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})
			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({
						group = "lsp-highlight",
						buffer = event2.buf,
					})
				end,
			})
		end

		-- Toggle inlay hints (on by default via the LspAttach hook in
		-- lua/plugins/lsp_config.lua; this is the per-buffer off-switch)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})

-- Telescope
local function telescope_action(name, opts)
	opts = opts or {}
	return function()
		require("telescope.builtin")[name](opts)
	end
end

vim.keymap.set("n", "<leader>sh", telescope_action("help_tags"), { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", telescope_action("keymaps"), { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", telescope_action("find_files"), { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>ss", telescope_action("builtin"), { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>sw", telescope_action("grep_string"), { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", telescope_action("live_grep"), { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", telescope_action("diagnostics"), { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", telescope_action("lsp_references"), { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", telescope_action("oldfiles"), { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", telescope_action("buffers"), { desc = "[ ] Find existing buffers" })

vim.keymap.set("n", "<leader>/", function()
	require("telescope.builtin").current_buffer_fuzzy_find(
		require("telescope.themes").get_dropdown({ winblend = 10, previewer = false })
	)
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>s/", function()
	require("telescope.builtin").live_grep({
		grep_open_files = true,
		prompt_title = "Live Grep in Open Files",
	})
end, { desc = "[S]earch [/] in Open Files" })

vim.keymap.set("n", "<leader>sn", function()
	require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

-- Terminals
vim.keymap.set("n", "<leader>to", "<CMD>2ToggleTerm direction=float<CR>", { desc = "Open floating terminal" })
vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- opencode terminal in a vertical split, created on first use
local opencode_term
vim.keymap.set("n", "<leader>ac", function()
	if not opencode_term then
		local Terminal = require("toggleterm.terminal").Terminal
		opencode_term = Terminal:new({
			cmd = "opencode",
			hidden = true,
			direction = "vertical",
			on_open = function(term)
				vim.cmd("wincmd H")
				vim.api.nvim_win_set_width(0, 121)
				vim.defer_fn(function()
					vim.api.nvim_win_set_width(0, 120)
				end, 500)
			end,
		})
	end
	opencode_term:toggle(120)
end, { desc = "Toggle opencode terminal" })

-- GitHub preview
vim.keymap.set("n", "<leader>mpo", function()
	require("github-preview").fns.toggle()
end)
vim.keymap.set("n", "<leader>mps", function()
	require("github-preview").fns.single_file_toggle()
end)
vim.keymap.set("n", "<leader>mpd", function()
	require("github-preview").fns.details_tags_toggle()
end)
