return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    local helpers = require("null-ls.helpers")
    local methods = require("null-ls.methods")
    local FORMATTING = methods.internal.FORMATTING
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    local toggle_state_file = vim.fn.stdpath("state") .. "/autoformat.toggle"

    -- 读取初始状态
    local function load_toggle_state()
      local ok, data = pcall(vim.fn.readfile, toggle_state_file)
      if ok and data and data[1] == "1" then
        return true
      else
        return false
      end
    end

    -- 写入状态
    local function save_toggle_state(state)
      vim.fn.writefile({ state and "1" or "0" }, toggle_state_file)
    end

    -- 初始化 toggle 状态
    vim.g.enable_autoformat = load_toggle_state()

    -- 使用 snacks 创建一个格式化按钮
    require("snacks").toggle
        .new({
          id = "auto_format",
          name = "Auto Format",
          get = function()
            return vim.g.enable_autoformat
          end,
          set = function(state)
            vim.g.enable_autoformat = state
            save_toggle_state(state) -- 保存状态
          end,
        })
        :map("<leader>tf") -- 映射按钮

    -- nix 官方格式化工具
    local nixfmt_rfc = {
      name = "nixfmt_rfc",
      method = FORMATTING,
      filetypes = { "nix" },
      generator = helpers.formatter_factory({
        command = "nixfmt",
        args = { "-" },
        to_stdin = true,
      }),
    }

    null_ls.setup({
      sources = {
        -- Nix
        -- null_ls.builtins.formatting.alejandra,
        -- null_ls.builtins.formatting.nixfmt_rfc,
        nixfmt_rfc,
        -- Lua
        null_ls.builtins.formatting.stylua,
        -- Python
        null_ls.builtins.formatting.black,
        -- TypeScript / JavaScript / CSS / Node
        null_ls.builtins.formatting.prettier,
        -- C / C++
        null_ls.builtins.formatting.clang_format,
        -- null_ls.builtins.diagnostics.clang_check,   -- optional: install clang tools
        -- markdown
        null_ls.builtins.formatting.prettier.with({ filetypes = { "markdown" } }),
        null_ls.builtins.diagnostics.markdownlint,
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          -- 自动格式化
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              if vim.g.enable_autoformat then
                vim.lsp.buf.format({ bufnr = bufnr })
              end
            end,
          })

          -- 手动格式化快捷键
          vim.keymap.set("n", "<leader>cf", function()
            vim.lsp.buf.format({ bufnr = bufnr })
          end, { buffer = bufnr, desc = "Format buffer with LSP" })
        end
      end,
    })
  end,
}
