--- 检查 lazy.nvim 插件是否已经存在于指定的路径。如果插件没有找到，就会从 GitHub 克隆 lazy.nvim 的 stable 分支
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
--- 将 lazy.nvim 插件路径添加到 Neovim 的运行时路径（runtimepath）中，以确保 Neovim 在启动时能够找到并加载该插件
vim.opt.rtp:prepend(lazypath)

---
require("lazy").setup({
  spec = {
    -- 定义了要加载的插件。这里加载了 LazyVim
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- 加载plugins目录下用户自定义的插件配置
    { import = "plugins" },
  },
  defaults = {
    -- 默认情况下，只有 LazyVim 插件会延迟加载，而用户自定义的插件会在启动时加载
    lazy = false,
    -- 不启用插件版本控制，使用最新的 Git 提交版本。如果你想强制使用稳定版或特定版本的插件，可以将其设置为 true 并指定版本
    version = false, -- always use the latest git commit
  },
  -- 指定在安装时自动使用的配色方案
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- 启用定期检查插件更新
    notify = false, -- 定期更新不进行通知
  },
  -- 禁用一些不常用的内建插件以提高 Neovim 启动速度
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
