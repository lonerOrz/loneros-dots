return {
	{
		"nvim-tree/nvim-web-devicons",
		opts = {
			override = {
				copilot = {
					icon = "",
					color = "#cba6f7", -- Catppuccin.mocha.mauve
					name = "Copilot",
				},
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"AndreM222/copilot-lualine",
		},
		opts = {
			options = {
				theme = "catppuccin",
				-- theme = "base16",
				always_divide_middle = false,
				-- component_separators = { left = "", right = "" },
				-- section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "lsp_status" },
				lualine_x = {},
				lualine_y = { "encoding", "fileformat", "filetype", "progress" },
				lualine_z = { "location" },
			},
			-- winbar 交由 lspsaga 来显示 lsp 相关
			-- winbar = {
			--   lualine_a = {},
			--   lualine_b = {
			--     { function() return " " end, color = 'Comment'},
			--   },
			--   lualine_x = {
			--     "lsp_status"
			--   }
			-- },
			-- inactive_winbar = {
			--   -- Always show winbar
			--   lualine_b = { function() return " " end },
			-- },
		},
		config = function(_, opts)
			local theme = require("catppuccin.palettes").get_palette("mocha")
			-- local theme = require("base16-colorscheme").colors

			local function show_macro_recording()
				local recording_register = vim.fn.reg_recording()
				if recording_register == "" then
					return ""
				else
					return "󰑋 " .. recording_register
				end
			end

			local macro_recording = {
				show_macro_recording,
				color = { fg = "#333333", bg = theme.red },
				separator = { left = "", right = "" },
				padding = 0,
			}

			local copilot = {
				"copilot",
				show_colors = true,
				symbols = {
					status = {
						hl = {
							enabled = theme.green,
							sleep = theme.overlay0,
							disabled = theme.surface0,
							warning = theme.peach,
							unknown = theme.red,
						},
					},
					spinner_color = theme.mauve,
				},
			}

			table.insert(opts.sections.lualine_x, 1, macro_recording)
			table.insert(opts.sections.lualine_c, copilot)

			require("lualine").setup(opts)
		end,
	},

	{
		"romgrk/barbar.nvim",
		version = "^1.0.0", -- optional: only update when a new 1.x version is released
		dependencies = {
			"lewis6991/gitsigns.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		event = { "VeryLazy" },
		keys = {
			{ "<A-<>", "<CMD>BufferMovePrevious<CR>", mode = { "n" }, desc = "[Buffer] Move buffer left" },
			{ "<A->>", "<CMD>BufferMoveNext<CR>", mode = { "n" }, desc = "[Buffer] Move buffer right" },
			{ "<A-1>", "<CMD>BufferGoto 1<CR>", mode = { "n" }, desc = "[Buffer] Go to buffer 1" },
			{ "<A-2>", "<CMD>BufferGoto 2<CR>", mode = { "n" }, desc = "[Buffer] Go to buffer 2" },
			{ "<A-3>", "<CMD>BufferGoto 3<CR>", mode = { "n" }, desc = "[Buffer] Go to buffer 3" },
			{ "<A-4>", "<CMD>BufferGoto 4<CR>", mode = { "n" }, desc = "[Buffer] Go to buffer 4" },
			{ "<A-5>", "<CMD>BufferGoto 5<CR>", mode = { "n" }, desc = "[Buffer] Go to buffer 5" },
			{ "<A-6>", "<CMD>BufferGoto 6<CR>", mode = { "n" }, desc = "[Buffer] Go to buffer 6" },
			{ "<A-7>", "<CMD>BufferGoto 7<CR>", mode = { "n" }, desc = "[Buffer] Go to buffer 7" },
			{ "<A-8>", "<CMD>BufferGoto 8<CR>", mode = { "n" }, desc = "[Buffer] Go to buffer 8" },
			{ "<A-9>", "<CMD>BufferGoto 9<CR>", mode = { "n" }, desc = "[Buffer] Go to buffer 9" },
			{ "<A-h>", "<CMD>BufferPrevious<CR>", mode = { "n" }, desc = "[Buffer] Previous buffer" },
			{ "<A-l>", "<CMD>BufferNext<CR>", mode = { "n" }, desc = "[Buffer] Next buffer" },
			{ "<A-w>", "<CMD>BufferClose<CR>", mode = { "n" }, desc = "Close buffer" },
		},
		opts = {
			animation = true,
			-- Automatically hide the tabline when there are this many buffers left.
			-- Set to any value >=0 to enable.
			auto_hide = 1,

			-- Set the filetypes which barbar will offset itself for
			sidebar_filetypes = {
				NvimTree = true, -- Use the default values: {event = 'BufWinLeave', text = '', align = 'left'}
			},
		},
	},

	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<leader>e", "<CMD>NvimTreeToggle<CR>", mode = { "n" }, desc = "[NvimTree] Toggle NvimTree" },
		},
		opts = {
			hijack_netrw = true,
			open_on_setup = true,
		},
	},

	{
		"HiPhish/rainbow-delimiters.nvim",
		main = "rainbow-delimiters.setup",
		submodules = false,
		opts = {},
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			-- {"rcarriga/nvim-notify", opts = {background_colour = "#000000"}}
		},
		keys = {
			-- { "<leader>n", "<CMD>Noice<CR>", desc = "[Noice] Show history messages" }, -- 历史消息 但是被 snacks 的 notifyer 接管
		},

		opts = {
			popupmenu = {
				enabled = false,
			},
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = false, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
			routes = {
				-- Hide search count
				{ filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
				-- Hide written message
				{ filter = { event = "msg_show", kind = "" }, opts = { skip = true } },
			},
		},
	},

	{
		"echasnovski/mini.diff",
		event = "VeryLazy",
		version = "*",
		opts = {},
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			---@type false | "classic" | "modern" | "helix"
			preset = "helix",
			win = {
				-- no_overlap = true,
				title = false,
				width = 0.5,
			},
      -- stylua: ignore
      spec = {
        -- { "<leader>cc", group = "<CodeCompanion>", icon = "" },
        { "<leader>s", group = "<Snacks>" },
        { "<leader>l", group = "<Lazygit>" },
        { "g", group = "<LSP>" },
        { "<leader>n", group = "<Notification>" },
        { "<leader>w", group = "<Workspace>" },
        { "<leader>t", group = "<Toggle UI>" },
        { "<leader>cc", group = "<CodeCompanion>", icon = "" },
        { "<leader>c", group = "<Code Action>" },
        { "<leader>y", group = "<Yazi>" },
        { "<leader>p", group = "<Session Manage>" },
      },
			-- expand all nodes wighout a description
			expand = function(node)
				return not node.desc
			end,
		},
		keys = {
      -- stylua: ignore
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "[Which-key] Buffer Local Keymaps", },
		},
	},

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			-- 处理超大文件（>10MB）时，自动禁用高开销的特性
			bigfile = { enabled = true },
			-- 关闭该内置资源管理器
			explorer = { enabled = false },
			-- 预览图片、LaTeX 公式
			image = {
				enabled = true,
				doc = { inline = false, float = true, max_width = 80, max_height = 40 },
				math = { latex = { font_size = "small" } },
			},
			-- 增强缩进可视化和作用域高亮
			indent = {
				enabled = true,
				animate = {
					enabled = false,
				},
				indent = {
					only_scope = true,
				},
				scope = {
					enabled = true, -- enable highlighting the current scope
					underline = true, -- underline the start of the scope
				},
				chunk = {
					-- when enabled, scopes will be rendered as chunks, except for the top-level scope which will be rendered as a scope.
					enabled = true,
				},
			},
			-- 增强用户输入交互
			input = { enabled = true },
			-- 使用snacks的 notifier 替换 nvim-notify
			notifier = {
				enabled = true,
				style = "notification",
			},
			-- picker
			picker = {
				enabled = true,
				previewers = {
					git = {
						builtin = false, -- use Neovim for previewing git output (true) or use git (false)
						args = {}, -- additional arguments passed to the git command. Useful to set pager options using `-c ...`
					},
				},
				sources = {
					spelling = {
						layout = { preset = "select" },
					},
				},
				layout = {
					preset = "telescope",
				},
			},
			-- 在编辑器左侧 “状态列” 显示行号、符号、折叠指示等
			statuscolumn = { enabled = true },
			-- 内置终端管理器，可以一键打开/关闭浮动终端
			terminal = {
				enabled = true,
			},
			-- 文档中的 “单词引用” 跳转 (例如快速跳转到下一个相同单词出现处)
			words = { enabled = true },
			-- 浮动终端窗口的外观
			styles = {
				terminal = {
					relative = "editor",
					border = "rounded",
					position = "float",
					backdrop = 60, -- 背景透明度
					height = 0.7,
					width = 0.7,
					zindex = 50, -- 层级高度
				},
			},
			-- 主页设置
			dashboard = {
				preset = {
					pick = function(cmd, opts)
						return LazyVim.pick(cmd, opts)()
					end,
					header = [[
███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗
████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║
██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║
██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
          ]],
          -- stylua: ignore
          ---@type snacks.dashboard.Item[]
          keys = {
            -- { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "f", desc = "Find File", action = ":lua require('fzf-lua').files()" },
            { icon = " ", key = "c", desc = "Config", action = ":lua require('fzf-lua').files({ cwd = vim.fn.stdpath('config') })" },
            { icon = " ", key = "x", desc = "Mason", action = ":Mason" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
				},
			},
		},
		-- 自定义快捷键
		keys = {
			-- 替换 noice 的 buffer 操作
			{
				"<A-w>",
				function()
					require("snacks").bufdelete()
				end,
				desc = "[Snacks] Delete buffer",
			},
			-- 显示图像
			{
				"<leader>si",
				function()
					require("snacks").image.hover()
				end,
				desc = "[Snacks] Display image",
			},
			-- 打开/关闭 terminal
			{
				"<A-i>",
				function()
					require("snacks").terminal()
				end,
				desc = "[Snacks] Toggle terminal",
				mode = { "n", "t" },
			},

			-- Notification
			{
				"<leader>ns",
				function()
					require("snacks").picker.notifications()
				end,
				desc = "[Snacks] Notification history",
			},
			{
				"<leader>nu",
				function()
					require("snacks").notifier.hide()
				end,
				desc = "[Snacks] Dismiss all notifications",
			},

			-- Top Pickers & Explorer
			-- TODO fzf-lua
			-- { "<leader><space>", function() require("snacks").picker.smart() end, desc = "[Snacks] Smart find files" },
			{
				"<leader>,",
				function()
					require("snacks").picker.buffers()
				end,
				desc = "[Snacks] Buffers",
			},
			-- find
			{
				"<leader>sb",
				function()
					require("snacks").picker.buffers()
				end,
				desc = "[Snacks] Buffers",
			},
			{
				"<leader>sf",
				function()
					require("snacks").picker.files()
				end,
				desc = "[Snacks] Find files",
			},
			{
				"<leader>sp",
				function()
					require("snacks").picker.projects()
				end,
				desc = "[Snacks] Projects",
			},
			{
				"<leader>sr",
				function()
					require("snacks").picker.recent()
				end,
				desc = "[Snacks] Recent",
			},
			-- git
			{
				"<leader>lb",
				function()
					require("snacks").git.blame_line()
				end,
				desc = "[Snacks] Git blame line",
			},
			-- Grep
			-- { "<leader>sb", function() require("snacks").picker.lines() end, desc = "[Snacks] Buffer lines" },
			-- { "<leader>sB", function() require("snacks").picker.grep_buffers() end, desc = "[Snacks] Grep open buffers" },
			{
				"<leader>sg",
				function()
					require("snacks").picker.grep()
				end,
				desc = "[Snacks] Grep",
			},
			{
				"<leader>sw",
				function()
					require("snacks").picker.grep_word()
				end,
				desc = "[Snacks] Visual selection or word",
				mode = { "n", "x" },
			},
			-- search
			{
				'<leader>s"',
				function()
					require("snacks").picker.registers()
				end,
				desc = "[Snacks] Registers",
			},
			{
				"<leader>s/",
				function()
					require("snacks").picker.search_history()
				end,
				desc = "[Snacks] Search history",
			},
			{
				"<leader>sa",
				function()
					require("snacks").picker.spelling()
				end,
				desc = "[Snacks] Spelling",
			},
			{
				"<leader>sA",
				function()
					require("snacks").picker.autocmds()
				end,
				desc = "[Snacks] Autocmds",
			},
			{
				"<leader>s:",
				function()
					require("snacks").picker.command_history()
				end,
				desc = "[Snacks] Command history",
			},
			{
				"<leader>sc",
				function()
					require("snacks").picker.commands()
				end,
				desc = "[Snacks] Commands",
			},
			{
				"<leader>sd",
				function()
					require("snacks").picker.diagnostics()
				end,
				desc = "[Snacks] Diagnostics",
			},
			{
				"<leader>sD",
				function()
					require("snacks").picker.diagnostics_buffer()
				end,
				desc = "[Snacks] Diagnostics buffer",
			},
			{
				"<leader>sh",
				function()
					require("snacks").picker.help()
				end,
				desc = "[Snacks] Help pages",
			},
			{
				"<leader>sH",
				function()
					require("snacks").picker.highlights()
				end,
				desc = "[Snacks] Highlights",
			},
			{
				"<leader>sI",
				function()
					require("snacks").picker.icons()
				end,
				desc = "[Snacks] Icons",
			},
			{
				"<leader>sj",
				function()
					require("snacks").picker.jumps()
				end,
				desc = "[Snacks] Jumps",
			},
			{
				"<leader>sk",
				function()
					require("snacks").picker.keymaps()
				end,
				desc = "[Snacks] Keymaps",
			},
			{
				"<leader>sl",
				function()
					require("snacks").picker.loclist()
				end,
				desc = "[Snacks] Location list",
			},
			{
				"<leader>sm",
				function()
					require("snacks").picker.marks()
				end,
				desc = "[Snacks] Marks",
			},
			{
				"<leader>sM",
				function()
					require("snacks").picker.man()
				end,
				desc = "[Snacks] Man pages",
			},
			{
				"<leader>sp",
				function()
					require("snacks").picker.lazy()
				end,
				desc = "[Snacks] Search for plugin spec",
			},
			{
				"<leader>sq",
				function()
					require("snacks").picker.qflist()
				end,
				desc = "[Snacks] Quickfix list",
			},
			{
				"<leader>sr",
				function()
					require("snacks").picker.resume()
				end,
				desc = "[Snacks] Resume",
			},
			{
				"<leader>su",
				function()
					require("snacks").picker.undo()
				end,
				desc = "[Snacks] Undo history",
			},

			-- LSP 覆盖之前的lsp定义
			-- { "gd", function() require("snacks").picker.lsp_definitions() end, desc = "[Snacks] Goto definition" },
			-- { "gD", function() require("snacks").picker.lsp_declarations() end, desc = "[Snacks] Goto declaration" },
			-- { "gr", function() require("snacks").picker.lsp_references() end, desc = "[Snacks] References" },
			-- { "gI", function() require("snacks").picker.lsp_implementations() end, desc = "[Snacks] Goto implementation" },
			-- { "gy", function() require("snacks").picker.lsp_type_definitions() end, desc = "[Snacks] Goto t[y]pe definition" },
			{
				"gs",
				function()
					require("snacks").picker.lsp_symbols()
				end,
				desc = "[Snacks] LSP symbols",
			},
			{
				"gS",
				function()
					require("snacks").picker.lsp_workspace_symbols()
				end,
				desc = "[Snacks] LSP workspace symbols",
			},

			-- Words
			{
				"]]",
				function()
					require("snacks").words.jump(vim.v.count1)
				end,
				desc = "[Snacks] Next Reference",
				mode = { "n", "t" },
			},
			{
				"[[",
				function()
					require("snacks").words.jump(-vim.v.count1)
				end,
				desc = "[Snacks] Prev Reference",
				mode = { "n", "t" },
			},

			-- Zen mode
			{
				"<leader>sz",
				function()
					require("snacks").zen()
				end,
				desc = "[Snacks] Toggle Zen Mode",
			},
		},

		init = function()
			local Snacks = require("snacks")
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Setup some globals for debugging (lazy-loaded)
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end
					_G.bt = function()
						Snacks.debug.backtrace()
					end
					vim.print = _G.dd -- Override print to use snacks for `:=` command
					-- 动画开关
					Snacks.toggle
						.new({
							id = "Animation",
							name = "Animation",
							get = function()
								return Snacks.animate.enabled()
							end,
							set = function(state)
								vim.g.snacks_animate = state
							end,
						})
						:map("<leader>ta")
					-- 滚动动画
					Snacks.toggle
						.new({
							id = "scroll_anima",
							name = "Scroll animation",
							get = function()
								return Snacks.scroll.enabled
							end,
							set = function(state)
								if state then
									Snacks.scroll.enable()
								else
									Snacks.scroll.disable()
								end
							end,
						})
						:map("<leader>tS")

					-- Create some toggle mappings
					Snacks.toggle.dim():map("<leader>tD")

					Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
					Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
					Snacks.toggle.diagnostics():map("<leader>td")
					Snacks.toggle.line_number():map("<leader>tl")
					Snacks.toggle
						.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
						:map("<leader>tc")
					Snacks.toggle.treesitter():map("<leader>tT")
					Snacks.toggle
						.option("background", { off = "light", on = "dark", name = "Dark Background" })
						:map("<leader>tb")
					Snacks.toggle.inlay_hints():map("<leader>th")
					Snacks.toggle.indent():map("<leader>tg")
					Snacks.toggle.dim():map("<leader>tD")
					-- Toggle the profiler
					Snacks.toggle.profiler():map("<leader>tpp")
					-- Toggle the profiler highlights
					Snacks.toggle.profiler_highlights():map("<leader>tph")

					vim.keymap.del("n", "grn")
					vim.keymap.del("n", "gra")
					vim.keymap.del("n", "grr")
					vim.keymap.del("n", "gri")

					vim.api.nvim_set_hl(0, "SnacksPickerListCursorLine", { bg = "#313244" })
				end,
			})
		end,
	},
}
