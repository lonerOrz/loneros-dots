-- 设置全局和本地的 <leader> 键
vim.g.mapleader = " "       -- 设置全局 <leader> 键为空格
vim.g.maplocalleader = "\\" -- 设置本地 <leader> 键为反斜杠

-- LazyVim 自动格式化开关
-- vim.g.autoformat = true -- 启用自动格式化功能

-- 搜索相关设置
vim.opt.ignorecase = true -- 搜索时忽略大小写
vim.opt.smartcase = true  -- 如果搜索模式包含大写字母，则搜索时大小写敏感
vim.opt.hlsearch = true   -- 高亮搜索结果
vim.opt.incsearch = true  -- 搜索内容时实时跳转结果

-- 滚动设置
vim.opt.scrolloff = 15      -- 光标上下保留15行的滚动偏移
vim.opt.sidescrolloff = 10  -- 光标左右保留10列的滚动偏移
vim.opt.startofline = false -- 保持光标在行内当前位置，不自动跳到行首

-- 隐藏级别设置
  vim.opt.conceallevel = 2 -- 设置隐藏文本的级别（用于Markdown等文件）

-- Tab 和缩进相关设置
vim.opt.tabstop = 2        -- Tab 显示为 2 个空格宽
vim.opt.softtabstop = 2    -- 按下Tab键时插入2个空格
vim.opt.shiftwidth = 2     -- 设置自动缩进的空格数为2
vim.opt.expandtab = true   -- 将Tab键转换为空格
vim.opt.smartindent = true -- 启用智能缩进

-- 分屏相关设置
vim.opt.splitbelow = true                               -- 新的水平分屏窗口出现在当前窗口下方
vim.opt.splitright = true                               -- 新的垂直分屏窗口出现在当前窗口右侧

vim.opt.clipboard = "unnamedplus"                       -- 系统剪切板

vim.opt.completeopt = { "menu", "menuone", "noselect" } -- 不自动选中补全项

-- 显示制表符和尾随空格
vim.opt.list = true                              -- 启用不可见字符的显示
vim.opt.listchars = { trail = "-", space = "·" } -- 设置制表符和尾随空格的显示符号

-- 行号
vim.opt.number = true
vim.opt.relativenumber = true
vim.wo.cursorline = true     -- 高亮显示当前行
vim.wo.wrap = false          -- 禁用自动换行

vim.opt.termguicolors = true -- 使用 24-bit RGB 色彩

-- 可以选择在其他地方添加打开浮窗的配置
vim.diagnostic.open_float(nil, { focusable = true }) -- 默认打开浮窗并聚焦

-- undo 持久化
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- 禁用 netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 光标样式
vim.opt.guicursor = {
  "n-v-c:block",                          -- 普通/可视/命令模式：方块光标
  "i-ci-ve:ver10",                        -- 插入/命令行插入/可视选择：垂直条光标（15%宽）
  "r-cr:hor20",                           -- 替换/命令行替换模式：横线光标（20%高）
  "o:hor50",                              -- 操作等待模式
  "a:blinkon500-blinkoff500-blinkwait500", -- 所有模式光标闪烁
}

-- 光标定位
vim.opt.cursorline = true
-- vim.opt.cursorcolumn = true
