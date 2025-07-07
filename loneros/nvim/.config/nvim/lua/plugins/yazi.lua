return {
  {
    "mikavilpas/yazi.nvim",
    dependencies = { "folke/snacks.nvim" },
    -- stylua: ignore
    keys = {
      { "<leader>ya", "<CMD>Yazi<CR>",        desc = "[Yazi] open at the current file", mode = { "n", "v" } },
      { "<leader>yw", "<CMD>Yazi cwd<CR>",    desc = "[Yazi] open in working directory" },
      { "<leader>yr", "<CMD>Yazi toggle<CR>", desc = "[Yazi] Resume the last session" },
    },
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
  },
}
