return {
	-- 自动补全括号
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
		},
	},
	-- 删除多余空格
	{
		"cappyzawa/trim.nvim",
		event = "BufWritePre",
		opts = {},
	},
	-- 快速跳转
	{
		"folke/flash.nvim",
		event = "BufReadPost",
		opts = {
			label = {
				rainbow = {
					enabled = true,
					shade = 1,
				},
			},
			modes = {
				char = {
					enabled = false,
				},
			},
		},
		keys = {
			{
				"<leader>f",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "[Flash] Jump",
			},
			{
				"<leader>F",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "[Flash] Treesitter",
			},
			{
				"<leader>F",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "[Flash] Treesitter Search",
			},
			{
				"<c-f>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "[Flash] Toggle Search",
			},
			{
				"<leader>j",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump({
						search = { mode = "search", max_length = 0 },
						label = { after = { 0, 0 }, matches = false },
						jump = { pos = "end" },
						pattern = "^\\s*\\S\\?", -- match non-whitespace at start plus any character (ignores empty lines)
					})
				end,
				desc = "[Flash] Line jump",
			},
		},
	},
	-- 高亮 TODO FIX NOTE 等
	-- TODO: xxxx
	{
		"folke/todo-comments.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"folke/snacks.nvim",
		},
		event = "VeryLazy",
		keys = {
			---@diagnostic disable-next-line: undefined-field
			{
				"<leader>st",
				function()
					require("snacks").picker.todo_comments({
						keywords = { "TODO", "FIX", "FIXME", "BUG", "FIXIT", "HACK", "WARN", "ISSUE" },
					})
				end,
				desc = "[TODO] Pick todos (without NOTE)",
			},
			---@diagnostic disable-next-line: undefined-field
			{
				"<leader>sT",
				function()
					require("snacks").picker.todo_comments()
				end,
				desc = "[TODO] Pick todos (with NOTE)",
			},
		},
		config = true,
	},
	-- unix shell 命令
	{
		"tpope/vim-eunuch",
		event = "VeryLazy",
		-- :Remove: Delete a file on disk without E211: File no longer available.
		-- :Delete: Delete a file on disk and the buffer too.
		-- :Move: Rename a buffer and the file on disk simultaneously. See also :Rename, :Copy, and :Duplicate.
		-- :Chmod: Change the permissions of the current file.
		-- :Mkdir: Create a directory, defaulting to the parent of the current file.
		-- :Cfind: Run find and load the results into the quickfix list.
		-- :Clocate: Run locate and load the results into the quickfix list.
		-- :Lfind/:Llocate: Like above, but use the location list.
		-- :Wall: Write every open window. Handy for kicking off tools like guard.
		-- :SudoWrite: Write a privileged file with sudo.
		-- :SudoEdit: Edit a privileged file with sudo.
		-- Typing a shebang line causes the file type to be re-detected. Additionally the file will be automatically made executable (chmod +x) after the next write.
		keys = {},
	},
}
