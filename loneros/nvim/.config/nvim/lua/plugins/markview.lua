return {
	"OXY2DEV/markview.nvim",
	lazy = false, -- Recommended
	ft = "markdown", -- If you decide to lazy-load anyway

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		require("markview").setup({
			experimental = {
				check_rtp_message = false, -- 关闭加载顺序提示信息
			},
		})
	end,
}
