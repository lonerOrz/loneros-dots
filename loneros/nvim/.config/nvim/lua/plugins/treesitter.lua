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
					-- ── 系统语言 ─────────────────────────────
					"c", -- C 语言
					"rust", -- Rust 语言
					"go", -- Go 语言

					-- ── Shell & 构建工具 ─────────────────────
					"bash", -- Shell 脚本
					"make", -- Makefile
					"cmake", -- CMake 构建工具
					"just", -- justfile 支持（类 make）

					-- ── Vim / Neovim / Treesitter 自身 ───────
					"vim", -- Vim 脚本
					"vimdoc", -- Vim 文档
					"query", -- Treesitter 查询语言
					"lua", -- Lua 脚本（Neovim 配置）

					-- ── 配置语言 ─────────────────────────────
					"json", -- JSON 配置
					"yaml", -- YAML 配置
					"toml", -- TOML 配置
					"ini", -- INI 配置
					"nix", -- Nix 配置管理
					"dockerfile", -- Dockerfile 支持

					-- ── 前端开发 ─────────────────────────────
					"javascript", -- JavaScript
					"typescript", -- TypeScript
					"tsx", -- TSX (React JSX)
					"html", -- HTML
					"css", -- CSS
					"scss", -- SCSS
					"svelte", -- Svelte 框架

					-- ── 后端开发 ─────────────────────────────
					"elixir", -- Elixir 后端语言
					"heex", -- Phoenix LiveView 模板
					"python", -- Python

					-- ── 数据 & 查询语言 ──────────────────────
					"sql", -- SQL 数据库查询
					"regex", -- 正则表达式

					-- ── 文档与笔记 ───────────────────────────
					"markdown", -- Markdown 文档
					"latex", -- LaTeX 文档排版
					"typst", -- Typst（LaTeX 替代）
					-- "norg", -- Neorg 笔记系统: error: invalid argument '-std=c11' not allowed with 'C++'
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}
