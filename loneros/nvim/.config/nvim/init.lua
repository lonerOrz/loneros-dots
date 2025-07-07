-- Add mason bin path to PATH
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath("data") .. "/mason/bin"

require("config.options")
require("config.lazy")
require("config.keymaps")
