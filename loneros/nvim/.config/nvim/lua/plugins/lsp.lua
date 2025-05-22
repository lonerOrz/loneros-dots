return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- "lua-language-server",
        -- "rust-analyzer",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    event = { "BufReadPre", "BufNewFile" }, -- 延迟加载
    config = function()
      -- 设置 Mason 和 LSP 配置
      require("mason-lspconfig").setup()

      local lspconfig = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- 遍历已安装的服务器并为每个服务器进行配置
      -- for _, server_name in ipairs(require("mason-lspconfig").get_installed_servers()) do
      --   lspconfig[server_name].setup({
      --     capabilities = capabilities,
      --   })
      -- end
    end
  },
  {
   "glepnir/lspsaga.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("lspsaga").setup({
        symbol_in_winbar = { enable = true, separator = "  ", show_file = true },
      })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { 'saghen/blink.cmp', "williamboman/mason.nvim" },

    -- example calling setup directly for each LSP
    config = function()
      vim.diagnostic.config({
        underline = false,
        signs = false,
        update_in_insert = false,
        virtual_text = { spacing = 2, prefix = "●" },
        severity_sort = true,
        float = {
          border = "rounded",
        },
      })

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local lspconfig = require('lspconfig')

      -- lspconfig['lua_ls'].setup({ capabilities = capabilities })

      -- Use LspAttach autocommand to only map the following keys
      -- aftpsaga hover_docr the language server attaches to the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)

          vim.diagnostic.open_float(nil, { focusable = true })
          local opts = { buffer = ev.buf }

          -- 查看文档说明（hover） vim.lsp.buf.hover
          vim.keymap.set("n", "K", "<CMD>Lspsaga hover_doc<CR>", {
            buffer = ev.buf,
            desc = "[LSP] Hover documentation",
          })

          -- 查看错误提示浮窗（diagnostic） vim.diagnostic.open_float
          vim.keymap.set("n", "<leader>d", "<CMD>Lspsaga show_workspace_diagnostics<CR>", {
            buffer = ev.buf,
            desc = "[LSP] Show diagnostics",
          })

          -- 显示函数签名（signature help
          vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, {
            buffer = ev.buf,
            desc = "[LSP] Signature help",
          })

          -- 跳转到定义（go to definition）
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
            buffer = ev.buf,
            desc = "[LSP] Go to definition",
          })

          -- 查找引用（谁用到了它）
          vim.keymap.set("n", "gr", vim.lsp.buf.references, {
            buffer = ev.buf,
            desc = "[LSP] Find references",
          })

          -- 回跳（返回跳转前的位置）← 这是 Neovim 内建的
          vim.keymap.set("n", "<C-o>", "<C-o>", {
            buffer = ev.buf,
            desc = "[LSP] Jump back",
          })

          -- 重命名符号（rename）
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
            buffer = ev.buf,
            desc = "[LSP] Rename symbol",
          })

          -- 添加当前目录为 workspace folder
          vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, {
            buffer = ev.buf,
            desc = "[LSP] Add workspace folder",
          })

          -- 移除当前目录或指定目录的 workspace folder
          vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, {
            buffer = ev.buf,
            desc = "[LSP] Remove workspace folder",
          })

          -- 列出当前所有 workspace folders（调试时用）
          vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, {
            buffer = ev.buf,
            desc = "[LSP] List workspace folders",
          })
        end,
      })
    end
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
