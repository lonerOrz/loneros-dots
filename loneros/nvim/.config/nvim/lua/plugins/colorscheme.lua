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
          LineNr     = { fg = colors.surface2 },
          Visual     = { bg = colors.overlay0 },
          Search     = { bg = colors.surface2 },
          IncSearch  = { bg = colors.lavender },
          CurSearch  = { bg = colors.lavender },
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
      }
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)

      vim.cmd.colorscheme("catppuccin")
    end
  },
}
