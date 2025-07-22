return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate" },
		opts = {
			ensure_installed = {
				-- "lua-language-server",
				-- "rust-analyzer",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		-- event = { "BufReadPre", "BufNewFile" }, -- 延迟加载
		event = "VeryLazy",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		opts = {
			automatic_enable = {
				exclude = { "nil_ls" },
			},
		},
		config = function(_, opts)
			-- 设置 Mason 和 LSP 配置
			require("mason-lspconfig").setup(opts)

			-- local lspconfig = require("lspconfig")
			-- local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- 遍历已安装的服务器并为每个服务器进行配置
			-- for _, server_name in ipairs(require("mason-lspconfig").get_installed_servers()) do
			--   lspconfig[server_name].setup({
			--     capabilities = capabilities,
			--   })
			-- end
		end,
	},
	{
		"glepnir/lspsaga.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lspsaga").setup({
				symbol_in_winbar = { enable = true, separator = "  ", show_file = true },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "saghen/blink.cmp", "williamboman/mason.nvim" },

		-- example calling setup directly for each LSP
		config = function()
			vim.diagnostic.config({
				underline = true,
				signs = false,
				update_in_insert = false,
				virtual_text = { spacing = 2, prefix = "●" },
				severity_sort = true,
				float = {
					border = "rounded",
				},
			})
			-- ====== 加强诊断提示颜色和符号可见性 ======
			vim.cmd([[
        highlight! DiagnosticUnderlineError guisp=#FF0000 gui=undercurl
        highlight! DiagnosticVirtualTextError guifg=#FF4C4C
        highlight! link DiagnosticHint DiagnosticWarn
      ]])

			local lspconfig = require("lspconfig")
			local blink_cmp = require("blink.cmp")
			local util = require("lspconfig.util")

			-- 如果使用 nil_ls
			-- lspconfig.nil_ls.setup({
			-- 	capabilities = blink_cmp.get_lsp_capabilities(),
			-- 	root_dir = util.root_pattern("flake.nix", ".git"),
			-- 	settings = {
			-- 		["nil"] = {
			-- 			nix = {
			-- 				flake = {
			-- 					autoEvalInputs = false,
			-- 					autoArchive = false,
			-- 				},
			-- 			},
			-- 		},
			-- 	},
			-- })
			-- lspconfig['lua_ls'].setup({ capabilities = capabilities })

			-- Use LspAttach autocommand to only map the following keys
			-- aftpsaga hover_docr the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					vim.diagnostic.open_float(nil, { focusable = true })
					local opts = { buffer = ev.buf }

					-- 查看文档说明（hover） vim.lsp.buf.hover
					vim.keymap.set("n", "K", "<CMD>Lspsaga hover_doc<CR>", {
						buffer = ev.buf,
						desc = "[LSP] Hover documentation",
					})

					-- 查看错误提示浮窗（diagnostic） vim.diagnostic.open_float
					-- vim.keymap.set("n", "<leader>cd", "<CMD>Lspsaga show_workspace_diagnostics<CR>", {
					--   buffer = ev.buf,
					--   desc = "[LSP] Show diagnostics",
					-- })

					-- 显示函数签名（signature help
					vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, {
						buffer = ev.buf,
						desc = "[LSP] Signature help",
					})

					-- 跳转到定义（go to definition）
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
						buffer = ev.buf,
						desc = "[LSP] Go to definition",
					})

					-- 查找引用（谁用到了它）
					vim.keymap.set("n", "gr", vim.lsp.buf.references, {
						buffer = ev.buf,
						desc = "[LSP] Find references",
					})

					-- 回跳（返回跳转前的位置）← 这是 Neovim 内建的
					vim.keymap.set("n", "<C-o>", "<C-o>", {
						buffer = ev.buf,
						desc = "[LSP] Jump back",
					})

					-- 重命名符号（rename）
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
						buffer = ev.buf,
						desc = "[LSP] Rename symbol",
					})

					-- 触发 code action（代码修复、导入等）
					vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", {
						buffer = ev.buf,
						desc = "[LSP] Code action",
					})

					-- 添加当前目录为 workspace folder
					vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, {
						buffer = ev.buf,
						desc = "[LSP] Add workspace folder",
					})

					-- 移除当前目录或指定目录的 workspace folder
					vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, {
						buffer = ev.buf,
						desc = "[LSP] Remove workspace folder",
					})

					-- 列出当前所有 workspace folders（调试时用）
					vim.keymap.set("n", "<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, {
						buffer = ev.buf,
						desc = "[LSP] List workspace folders",
					})
				end,
			})
		end,
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
	{
		-- 代码诊断显示信息
		"folke/trouble.nvim",
		cmd = "Trouble",
		keys = {
			{
				"<A-j>",
				function()
					vim.diagnostic.jump({ count = 1 })
				end,
				mode = { "n" },
				desc = "Go to next diagnostic",
			},
			{
				"<A-k>",
				function()
					vim.diagnostic.jump({ count = -1 })
				end,
				mode = { "n" },
				desc = "Go to previous diagnostic",
			},

			{
				"<leader>cd",
				"<CMD>Trouble diagnostics toggle<CR>",
				desc = "[Trouble] Toggle buffer diagnostics",
			},
			{ "<leader>cs", "<CMD>Trouble symbols toggle focus=false<CR>", desc = "[Trouble] Toggle symbols " },
			-- { "<leader>gl", "<CMD>Trouble lsp toggle focus=false win.position=right<CR>", desc = "[Trouble] Toggle LSP definitions/references/...", },
			-- { "<leader>gL", "<CMD>Trouble loclist toggle<CR>",                            desc = "[Trouble] Location List" },
			-- { "<leader>gq", "<CMD>Trouble qflist toggle<CR>",                             desc = "[Trouble] Quickfix List" },

			-- { "grr", "<CMD>Trouble lsp_references focus=true<CR>",         mode = { "n" }, desc = "[Trouble] LSP references"                        },
			-- { "gD", "<CMD>Trouble lsp_declarations focus=true<CR>",        mode = { "n" }, desc = "[Trouble] LSP declarations"                      },
			-- { "gd", "<CMD>Trouble lsp_type_definitions focus=true<CR>",    mode = { "n" }, desc = "[Trouble] LSP type definitions"                  },
			-- { "gri", "<CMD>Trouble lsp_implementations focus=true<CR>",    mode = { "n" }, desc = "[Trouble] LSP implementations"                   },
		},

		-- specs = {
		--   "folke/snacks.nvim",
		--   opts = function(_, opts)
		--     return vim.tbl_deep_extend("force", opts or {}, {
		--       picker = {
		--         actions = require("trouble.sources.snacks").actions,
		--         win = {
		--           input = {
		--             -- stylua: ignore
		--             keys = {
		--               ["<c-t>"] = { "trouble_open", mode = { "n", "i" }, },
		--             },
		--           },
		--         },
		--       },
		--     })
		--   end,
		-- },
		-- opts = {
		--   focus = false,
		--   warn_no_results = false,
		--   open_no_results = true,
		--   preview = {
		--     type = "float",
		--     relative = "editor",
		--     border = "rounded",
		--     title = "Preview",
		--     title_pos = "center",
		--     ---`row` and `col` values relative to the editor
		--     position = { 0.3, 0.3 },
		--     size = { width = 0.6, height = 0.5 },
		--     zindex = 200,
		--   },
		-- },

		-- lualine 的显示
		config = function(_, opts)
			require("trouble").setup(opts)
			local symbols = require("trouble").statusline({
				mode = "lsp_document_symbols",
				groups = {},
				title = false,
				filter = { range = true },
				format = "{kind_icon}{symbol.name:Normal}",
				-- The following line is needed to fix the background color
				-- Set it to the lualine section you want to use
				-- hl_group = "lualine_b_normal",
			})

			-- Insert status into lualine safely
			local lualine = require("lualine")
			local config = lualine.get_config()

			config.winbar = config.winbar or {}
			config.winbar.lualine_b = config.winbar.lualine_b or {}

			table.insert(config.winbar.lualine_b, 1, {
				symbols.get,
				cond = symbols.has,
			})

			lualine.setup(config)
		end,
	},
}
