return function()
	local fmt = string.format

	require("formatter").setup({
		["*"] = {
			-- remove trailing whitespaces
			{
				cmd = {
					"sed -i 's/[ \t]*$//'",
				},
			},
		},
		logging = false,
		filetype = {
			python = {
				function()
					return {
						exe = "yapf",
						args = {},
						stdin = "true",
					}
				end,
			},
			javascript = {
				-- prettier
				function()
					return {
						exe = "prettier",
						args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote" },
						stdin = true,
					}
				end,
			},
			rust = {
				-- Rustfmt
				function()
					return {
						exe = "rustfmt",
						args = { "--emit=stdout" },
						stdin = true,
					}
				end,
			},
			javascriptreact = {
				-- @usage can be prettier or eslint
				function()
					return {
						exe = "prettier",
						args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote" },
						stdin = true,
					}
				end,
			},
			lua = {
				-- luafmt
				function()
					return {
						exe = "stylua",
						args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
						stdin = false,
					}
				end,
			},
			cpp = {
				-- clang-format
				function()
					return {
						exe = "clang-format",
						args = {},
						stdin = true,
						cwd = vim.fn.expand("%:p:h"), -- Run clang-format in cwd of the file.
					}
				end,
			},
		},
	})
end
