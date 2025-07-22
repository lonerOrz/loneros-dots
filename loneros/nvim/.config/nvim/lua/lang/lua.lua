vim.lsp.enable("lua_ls")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true, -- 只有设置过nvim-treesitter才会加载
		opts = {
			ensure_installed = { "lua" },
		},
		opts_extend = { "ensure_installed" }, -- 以列表形式扩展opts的ensure_installed
	},

	{
		"williamboman/mason.nvim",
		optional = true,
		opts = {
			ensure_installed = {
				"lua-language-server",
				"stylua",
			},
		},
		opts_extend = { "ensure_installed" },
	},

	{
		"nvimtools/none-ls.nvim",
		opts = {
			sources = {
				require("null-ls").builtins.formatting.stylua,
			},
		},
		opts_extend = { "sources" },
	},

	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}
