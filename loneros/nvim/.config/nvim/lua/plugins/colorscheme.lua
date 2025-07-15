return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true,
      custom_highlights = function(colors)
        -- 自定义一些地方的颜色显示
        return {
          LineNr = { fg = colors.surface2 },
          Visual = { bg = colors.overlay0 },
          Search = { bg = colors.surface2 },
          IncSearch = { bg = colors.lavender },
          CurSearch = { bg = colors.lavender },
          MatchParen = { bg = colors.lavender, fg = colors.base, bold = true },
        }
      end,
      -- 开启一些插件的颜色配置
      integrations = {
        barbar = true,
        blink_cmp = true,
        gitsigns = true,
        mason = true,
        noice = true,
        notify = true,
        nvimtree = true,
        rainbow_delimiters = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "RRethy/base16-nvim",
    name = "base16-nvim",
    enabled = false,
    config = function()
      local theme = require("colors.customtheme") -- 你的 table
      require("base16-colorscheme").setup(theme, {
        colorspace = "256",                    -- 如果你的终端只支持 256 色
        -- 还可以在这里配置你想要的 integrations：
        barbar = true,
        blink_cmp = true,
        gitsigns = true,
        mason = true,
        noice = true,
        notify = true,
        nvimtree = true,
        rainbow_delimiters = true,
      })
      -- 3) 拿到注册好的颜色映射
      local C = require("base16-colorscheme").colors

      -- 4) 直接设置一波你需要的自定义高亮
      vim.api.nvim_set_hl(0, "LineNr", { fg = C.base03 })
      vim.api.nvim_set_hl(0, "Visual", { bg = C.base01 })
      vim.api.nvim_set_hl(0, "Search", { bg = C.base03 })
      vim.api.nvim_set_hl(0, "IncSearch", { bg = C.base0E })
      vim.api.nvim_set_hl(0, "CurSearch", { bg = C.base0E })
      vim.api.nvim_set_hl(0, "MatchParen", { bg = C.base0E, fg = C.base00, bold = true })
    end,
  },
}
