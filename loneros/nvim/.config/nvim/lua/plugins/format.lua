return {
	"nvimtools/none-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = function(_, user_opts)
		local null_ls = require("null-ls")
		local methods = require("null-ls.methods")
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		-- 自动格式化 toggle 文件
		local toggle_state_file = vim.fn.stdpath("state") .. "/autoformat.toggle"

		local function load_toggle_state()
			local ok, data = pcall(vim.fn.readfile, toggle_state_file)
			return ok and data and data[1] == "1"
		end

		local function save_toggle_state(state)
			vim.fn.writefile({ state and "1" or "0" }, toggle_state_file)
		end

		vim.g.enable_autoformat = load_toggle_state()

		-- snacks toggle 控制
		require("snacks").toggle
			.new({
				id = "auto_format",
				name = "Auto Format",
				get = function()
					return vim.g.enable_autoformat
				end,
				set = function(state)
					vim.g.enable_autoformat = state
					save_toggle_state(state)
				end,
			})
			:map("<leader>tf")

		-- Rustfmt 格式化
		local rustfmt = {
			method = null_ls.methods.FORMATTING,
			filetypes = { "rust" },
			generator = null_ls.generator({
				command = "rustfmt",
				args = { "--emit=stdout" },
				to_stdin = true,
			}),
		}

		-- Clippy 诊断
		local clippy = {
			method = null_ls.methods.DIAGNOSTICS,
			filetypes = { "rust" },
			generator = null_ls.generator({
				command = "cargo",
				args = { "clippy", "--message-format=json", "--quiet" },
				from_stderr = false,
				format = "json",
				-- 这里需要一个 parser，把 clippy 的 json 输出转成 diagnostics
				on_output = function(params, done)
					local diags = {}
					for _, item in ipairs(params.output or {}) do
						if item.reason == "compiler-message" and item.message then
							local msg = item.message
							table.insert(diags, {
								row = msg.spans[1] and msg.spans[1].line_start or 1,
								col = msg.spans[1] and msg.spans[1].column_start or 1,
								end_row = msg.spans[1] and msg.spans[1].line_end or 1,
								end_col = msg.spans[1] and msg.spans[1].column_end or 1,
								source = "clippy",
								message = msg.message,
								severity = vim.diagnostic.severity.WARN,
							})
						end
					end
					done(diags)
				end,
			}),
		}

		-- 默认 sources
		local default_sources = {
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.prettier,
			null_ls.builtins.formatting.clang_format,
			null_ls.builtins.formatting.prettier.with({ filetypes = { "markdown" } }),
			null_ls.builtins.diagnostics.markdownlint,
			rustfmt, -- Rust 格式化
			clippy, -- Rust 代码检查
		}

		-- lazy 会自动合并多个 opts.sources，这里我们显式处理合并
		local merged_sources = vim.list_extend(default_sources, user_opts.sources or {})

		return {
			sources = merged_sources,
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
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

					vim.keymap.set("n", "<leader>cf", function()
						vim.lsp.buf.format({ bufnr = bufnr })
					end, { buffer = bufnr, desc = "Format buffer with LSP" })
				end
			end,
		}
	end,
}
