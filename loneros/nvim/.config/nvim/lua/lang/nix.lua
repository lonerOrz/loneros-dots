-- ~/.config/nvim/lua/plugins/lang/nix.lua
return {
	{
		"nvim-treesitter/nvim-treesitter",
		ft = "nix",
		opts = {
			ensure_installed = { "nix" },
		},
	},
	{
		"nvimtools/none-ls.nvim",
		ft = "nix",
		opts = {
			sources = {
				{
					name = "nixfmt_rfc",
					method = require("null-ls").methods.FORMATTING,
					filetypes = { "nix" },
					generator = require("null-ls.helpers").formatter_factory({
						command = "nixfmt",
						args = {},
						to_stdin = true,
						ignore_stderr = true,
					}),
				},
			},
		},
		opts_extend = { "sources" },
	},
	{
		"neovim/nvim-lspconfig",
		ft = "nix",
		config = function()
			if vim.b._nixd_loaded then
				return
			end
			vim.b._nixd_loaded = true

			local lspconfig = require("lspconfig")
			local blink_cmp = require("blink.cmp")
			local util = require("lspconfig.util")

			-- 大部分使用的是 mason-lspconfig 自动启用流程
			-- nixd 不在 mason 里，所以需要手动配置
			lspconfig.nixd.setup({
				cmd = { "nixd" },
				filetypes = { "nix" },
				root_dir = util.root_pattern("flake.nix", ".git"),
				settings = {
					nixd = {
						nixpkgs = {
							expr = "import (builtins.getFlake(toString ./.)).inputs.nixpkgs { }",
						},
						stable = {
							expr = "import (builtins.getFlake(toString ./.)).inputs.nixpkgs-stable { }",
						},
						formatting = {
							command = { "nixfmt" },
						},
						options = {
							nixos = {
								expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.loneros.options',
							},
							home_manager = {
								expr = 'let flake = builtins.getFlake(toString ./.); in flake.homeConfigurations."loner@loneros".options',
							},
							-- 可以按需再加 nixos/darwin
						},
					},
				},
			})
		end,
	},
}
