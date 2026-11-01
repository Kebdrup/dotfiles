-- Ported from nvim-lspconfig (lsp/gopls.lua) — consumed as an rtp source by
-- Neovim 0.12 core (vim.lsp.config): :h lsp-config-runtime-package
--
-- [Settings documentation](https://go.dev/gopls/settings)
--
-- NOTE: since v0.22.0 gopls no longer advertises semantic tokens to clients
-- by default. To maintain previous behavior, semantic tokens are enabled on client side.
-- To disable this feature, set `semanticTokens` option to `false`.

local mod_cache = nil
local std_lib = nil

---@param envvar_id string
---@param custom_subdir string?
---@param on_complete fun(dir: string | nil)
local function identify_go_dir(envvar_id, custom_subdir, on_complete)
	local cmd = { "go", "env", envvar_id }
	vim.system(cmd, { text = true }, function(output)
		local res = vim.trim(output.stdout or "")
		if output.code == 0 and res ~= "" then
			if custom_subdir and custom_subdir ~= "" then
				res = res .. custom_subdir
			end
			on_complete(res)
		else
			vim.schedule(function()
				vim.notify(("[gopls] identify %s dir cmd failed with code %d: %s\n%s"):format(envvar_id, output.code, vim.inspect(cmd), output.stderr or ""))
			end)
			on_complete(nil)
		end
	end)
end

---@return string?
local function get_std_lib_dir()
	if std_lib and std_lib ~= "" then
		return std_lib
	end

	identify_go_dir("GOROOT", "/src", function(dir)
		if dir then
			std_lib = dir
		end
	end)
	return std_lib
end

---@return string?
local function get_mod_cache_dir()
	if mod_cache and mod_cache ~= "" then
		return mod_cache
	end

	identify_go_dir("GOMODCACHE", nil, function(dir)
		if dir then
			mod_cache = dir
		end
	end)
	return mod_cache
end

---@param fname string
---@return string?
local function get_root_dir(fname)
	if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
		local clients = vim.lsp.get_clients({ name = "gopls" })
		if #clients > 0 then
			return clients[#clients].config.root_dir
		end
	end
	if std_lib and fname:sub(1, #std_lib) == std_lib then
		local clients = vim.lsp.get_clients({ name = "gopls" })
		if #clients > 0 then
			return clients[#clients].config.root_dir
		end
	end
	return vim.fs.root(fname, "go.work") or vim.fs.root(fname, "go.mod") or vim.fs.root(fname, ".git")
end

---@type vim.lsp.Config
return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		get_mod_cache_dir()
		get_std_lib_dir()
		-- see: https://github.com/neovim/nvim-lspconfig/issues/804
		on_dir(get_root_dir(fname))
	end,
	settings = {
		gopls = {
			semanticTokens = true,
			-- gopls's hint categories are all off by default (hints = {}); names-only,
			-- matching ts_ls/basedpyright.
			hints = {
				parameterNames = true,
			},
		},
	},
}
