return function()
	local doomrc = require('doom.core.config.doomrc').load_doomrc()
	local functions = require('doom.core.functions')

	local function get_ts_parsers(languages)
		local langs = {}

		for _, lang in ipairs(languages) do
			-- If the lang is config then add parsers for JSON, YAML and TOML
			if lang == 'config' then
				table.insert(langs, 'json')
				table.insert(langs, 'yaml')
				table.insert(langs, 'toml')
			else
				lang = lang:gsub('%s+%+lsp', '')
				table.insert(langs, lang)
			end
		end
		return langs
	end

	-- Set up treesitter for Neorg
	local parser_configs =
		require('nvim-treesitter.parsers').get_parser_configs()
	parser_configs.norg = {
		install_info = {
			url = 'https://github.com/vhyrro/tree-sitter-norg',
			files = { 'src/parser.c' },
			branch = 'main',
		},
	}
	-- selene: allow(undefined_variable)
	if packer_plugins and packer_plugins['neorg'] then
		table.insert(doomrc.langs, 'norg')
	end

	require('nvim-treesitter.configs').setup({
		-- ensure_installed = get_ts_parsers(doomrc.langs),
		ensure_installed = 'all',
		ignore_install = {'haskell'},
		highlight = { enable = true },
		 playground = {
      enable = true,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
      keybindings = {
        toggle_query_editor = "o",
        toggle_hl_groups = "i",
        toggle_injected_languages = "t",
        toggle_anonymous_nodes = "a",
        toggle_language_display = "I",
        focus_language = "f",
        unfocus_language = "F",
        update = "R",
        goto_node = "<cr>",
        show_help = "?",
      },
            },
		autopairs = {
			enable = functions.is_plugin_disabled('autopairs') and false or true,
		},
		indent = { enable = false },
		tree_docs = { enable = true },
		context_commentstring = { enable = true },
		autotag = {
			enable = true,
			filetypes = {
				'html',
				'javascript',
				'javascriptreact',
				'typescriptreact',
				'svelte',
				'vue',
				'markdown',
			},
		},
	})
end
