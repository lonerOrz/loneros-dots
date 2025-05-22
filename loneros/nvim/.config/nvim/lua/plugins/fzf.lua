return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require('fzf-lua').setup {
      winopts = {
        height = 0.7,  -- 窗口高度
        width = 0.7,   -- 窗口宽度
        row = 0.5,     -- 窗口位置
        col = 0.5,     -- 窗口位置
        border = 'rounded', -- 窗口边框样式
      },
    }

    -- 设置 FZF 查找文件的快捷键
    vim.keymap.set("n", "<leader><space>", function()
      require('fzf-lua').files({ cwd = vim.fn.getcwd() })
    end, { desc = "[FZF] Find files (pwd)" })
  end
}
