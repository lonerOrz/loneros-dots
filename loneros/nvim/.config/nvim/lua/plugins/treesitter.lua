return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				auto_install = true,
				ensure_installed = {
					"c",
					"vim",
					"vimdoc",
					"query",
					"elixir",
					"heex",
					"javascript",
					"html",
					"rust",
					"go",
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}
