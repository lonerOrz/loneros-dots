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
      { "<leader>f", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "[Flash] Jump"              },
      { "<leader>F", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "[Flash] Treesitter"        },
      { "<leader>F", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "[Flash] Treesitter Search" },
      { "<c-f>",     mode = { "c" },           function() require("flash").toggle() end,            desc = "[Flash] Toggle Search"     },
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
      "folke/snacks.nvim"
    },
    event = "VeryLazy",
    keys = {
      ---@diagnostic disable-next-line: undefined-field
      { "<leader>st", function() require("snacks").picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME", "BUG", "FIXIT", "HACK", "WARN", "ISSUE"  } }) end, desc = "[TODO] Pick todos (without NOTE)", },
      ---@diagnostic disable-next-line: undefined-field
      { "<leader>sT", function() require("snacks").picker.todo_comments() end, desc = "[TODO] Pick todos (with NOTE)", },
    },
    config = true,
  },
}
