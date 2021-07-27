-- Doom modules, where all the magic goes
--
-- NOTE: We do not provide other LSP integration like coc.nvim, please refer
--       to our FAQ to see why.

local utils = require('doom.utils')
local functions = require('doom.core.functions')

---- Packer Bootstrap ---------------------------
-------------------------------------------------
local packer_path = vim.fn.stdpath('data')
	.. '/site/pack/packer/opt/packer.nvim'

if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
	vim.fn.system({
		'git',
		'clone',
		'https://github.com/wbthomason/packer.nvim',
		packer_path,
	})
end

-- Load packer
vim.cmd([[ packadd packer.nvim ]])
local packer = require('packer')

-- Change some defaults
packer.init({
	git = {
		clone_timeout = 300, -- 5 mins
	},
	profile = {
		enable = true,
	},
})

packer.startup(function(use)
	-----[[------------]]-----
	---     Essentials     ---
	-----]]------------[[-----
	-- Plugins manager
	use({
		'wbthomason/packer.nvim',
		opt = true,
	})

	-- Tree-Sitter
	use({
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = require('doom.modules.config.doom-treesitter'),
	})
	use({
		'JoosepAlviste/nvim-ts-context-commentstring',
		requires = { { 'Olical/aniseed', after = 'nvim-treesitter' } },
		after = 'nvim-treesitter',
	})
	use({
		'nvim-treesitter/nvim-tree-docs',
		after = 'nvim-treesitter',
	})
	use({
		'windwp/nvim-ts-autotag',
		after = 'nvim-treesitter',
	})

	-- Neorg
	local disabled_neorg = functions.is_plugin_disabled('neorg')
	use({
		'vhyrro/neorg',
		branch = 'unstable',
		config = require('doom.modules.config.doom-neorg'),
		disable = disabled_neorg,
		after = { 'nvim-treesitter' },
	})

	-- Sessions
	local disabled_sessions = functions.is_plugin_disabled('auto-session')
	use({
		'rmagatti/auto-session',
		config = require('doom.modules.config.doom-autosession'),
		requires = { { 'rmagatti/session-lens', after = 'telescope.nvim' } },
		cmd = { 'SaveSession', 'RestoreSession', 'DeleteSession' },
		module = 'auto-session',
		disable = disabled_sessions,
	})

	-----[[------------]]-----
	---     UI Related     ---
	-----]]------------[[-----
	-- Fancy start screen
	local disabled_dashboard = functions.is_plugin_disabled('dashboard')
	use({
		'glepnir/dashboard-nvim',
		config = require('doom.modules.config.doom-dashboard'),
		cmd = 'Dashboard',
		disable = disabled_dashboard,
	})

	-- Doom Colorschemes
	local disabled_doom_themes = functions.is_plugin_disabled('doom-themes')
	use({
		'GustavoPrietoP/doom-themes.nvim',
		disable = disabled_doom_themes,
		event = 'ColorSchemePre',
	})

	-- Development icons
	use({
		'kyazdani42/nvim-web-devicons',
		module = 'nvim-web-devicons',
	})

	-- File tree
	local disabled_tree = functions.is_plugin_disabled('explorer')
	use({
		'kyazdani42/nvim-tree.lua',
		requires = 'nvim-web-devicons',
		config = require('doom.modules.config.doom-tree'),
		disable = disabled_tree,
		cmd = {
			'NvimTreeClipboard',
			'NvimTreeClose',
			'NvimTreeFindFile',
			'NvimTreeOpen',
			'NvimTreeRefresh',
			'NvimTreeToggle',
		},
	})

	-- Statusline
	-- can be disabled to use your own statusline
	local disabled_statusline = functions.is_plugin_disabled('statusline')
	use({
		'glepnir/galaxyline.nvim',
		config = require('doom.modules.config.doom-eviline'),
		disable = disabled_statusline,
		event = 'ColorScheme',
	})

	-- Tabline
	-- can be disabled to use your own tabline
	local disabled_tabline = functions.is_plugin_disabled('tabline')
	use({
		'akinsho/nvim-bufferline.lua',
		config = require('doom.modules.config.doom-bufferline'),
		disable = disabled_tabline,
		event = 'ColorScheme',
	})

	-- Better terminal
	-- can be disabled to use your own terminal plugin
	local disabled_terminal = functions.is_plugin_disabled('terminal')
	use({
		'akinsho/nvim-toggleterm.lua',
		config = require('doom.modules.config.doom-toggleterm'),
		disable = disabled_terminal,
		module = { 'toggleterm', 'toggleterm.terminal' },
		cmd = { 'ToggleTerm', 'TermExec' },
		keys = { 'n', '<C-t>' },
	})

	-- Viewer & finder for LSP symbols and tags
	local disabled_outline = functions.is_plugin_disabled('symbols')
	use({
		'simrat39/symbols-outline.nvim',
		config = require('doom.modules.config.doom-symbols'),
		disable = disabled_outline,
		cmd = {
			'SymbolsOutline',
			'SymbolsOutlineOpen',
			'SymbolsOutlineClose',
		},
	})

	-- Minimap
	-- Depends on wfxr/code-minimap to work!
	local disabled_minimap = functions.is_plugin_disabled('minimap')
	use({
		'wfxr/minimap.vim',
		disable = disabled_minimap,
		cmd = {
			'Minimap',
			'MinimapClose',
			'MinimapToggle',
			'MinimapRefresh',
			'MinimapUpdateHighlight',
		},
	})

	-- Keybindings menu like Emacs's guide-key
	local disabled_whichkey = functions.is_plugin_disabled('which-key')
	use({
		'folke/which-key.nvim',
		opt = true,
		config = require('doom.modules.config.doom-whichkey'),
		disable = disabled_whichkey,
	})

	-- Distraction free environment
	local disabled_zen = functions.is_plugin_disabled('zen')
	use({
		'kdav5758/TrueZen.nvim',
		config = require('doom.modules.config.doom-zen'),
		disable = disabled_zen,
		module = 'true-zen',
		event = 'BufWinEnter',
	})

	-----[[--------------]]-----
	---     Fuzzy Search     ---
	-----]]--------------[[-----
	use({
		'nvim-lua/plenary.nvim',
		module = 'plenary',
	})
	use({
		'nvim-lua/popup.nvim',
		module = 'popup',
	})

	local disabled_telescope = functions.is_plugin_disabled('telescope')
	use({
		'nvim-telescope/telescope.nvim',
		cmd = 'Telescope',
		module = 'telescope',
		requires = {
			'popup.nvim',
			'plenary.nvim',
		},
		config = require('doom.modules.config.doom-telescope'),
		disable = disabled_telescope,
	})

	-----[[-------------]]-----
	---     GIT RELATED     ---
	-----]]-------------[[-----
	-- Git gutter better alternative, written in Lua
	-- can be disabled to use your own git gutter plugin
	local disabled_gitsigns = functions.is_plugin_disabled('gitsigns')
	use({
		'lewis6991/gitsigns.nvim',
		config = require('doom.modules.config.doom-gitsigns'),
		disable = disabled_gitsigns,
		requires = 'plenary.nvim',
		event = 'BufRead',
	})

	-- LazyGit integration
	local disabled_lazygit = functions.is_plugin_disabled('lazygit')
	use({
		'kdheepak/lazygit.nvim',
		requires = 'plenary.nvim',
		disable = disabled_lazygit,
		cmd = { 'LazyGit', 'LazyGitConfig' },
	})

	-----[[------------]]-----
	---     Completion     ---
	-----]]------------[[-----
	local disabled_lsp = functions.is_plugin_disabled('lsp')
	-- Built-in LSP Config
	use({
		'neovim/nvim-lspconfig',
		config = require('doom.modules.config.doom-lspconfig'),
		disable = disabled_lsp,
		event = 'ColorScheme',
	})

	-- Completion plugin
	-- can be disabled to use your own completion plugin
	use({
		'hrsh7th/nvim-compe',
		requires = {
			{
				'ray-x/lsp_signature.nvim',
				config = require('doom.modules.config.doom-lsp-signature'),
			},
		},
		config = require('doom.modules.config.doom-compe'),
		disable = disabled_lsp,
		opt = true,
		after = 'nvim-lspconfig',
	})

	-- Snippets
	local disabled_snippets = functions.is_plugin_disabled('snippets')
	use({
		'L3MON4D3/LuaSnip',
		config = require('doom.modules.config.doom-luasnip'),
		disable = disabled_snippets,
		requires = { 'rafamadriz/friendly-snippets' },
		event = 'BufWinEnter',
	})

	-- install lsp saga
	use({
		'glepnir/lspsaga.nvim',
		disable = disabled_lsp,
		opt = true,
		after = 'nvim-lspconfig',
	})

	-- provides the missing `:LspInstall` for `nvim-lspconfig`.
	use({
		'kabouzeid/nvim-lspinstall',
		config = require('doom.modules.config.doom-lspinstall'),
		disable = disabled_lsp,
		after = 'nvim-lspconfig',
	})

	-----[[--------------]]-----
	---     File Related     ---
	-----]]--------------[[-----
	-- Write / Read files without permissions (e.vim.g. /etc files) without having
	-- to use `sudo nvim /path/to/file`
	local disabled_suda = functions.is_plugin_disabled('suda')
	use({
		'lambdalisue/suda.vim',
		disable = disabled_suda,
		cmd = { 'SudaRead', 'SudaWrite' },
	})

	-- File formatting
	-- can be disabled to use your own file formatter
	local disabled_formatter = functions.is_plugin_disabled('formatter')
	use({
		'mhartington/formatter.nvim',
		config = require('doom.modules.config.doom-format'),
		disable = disabled_formatter,
		event = 'BufWinEnter',
	})

	-- Autopairs
	-- can be disabled to use your own autopairs
	local disabled_autopairs = functions.is_plugin_disabled('autopairs')
	use({
		'windwp/nvim-autopairs',
		config = require('doom.modules.config.doom-autopairs'),
		disable = disabled_autopairs,
		event = 'InsertEnter',
	})

	-- Indent Lines
	local disabled_indent_lines = functions.is_plugin_disabled('indentlines')
	use({
		'lukas-reineke/indent-blankline.nvim',
		config = require('doom.modules.config.doom-blankline'),
		disable = disabled_indent_lines,
		event = 'ColorScheme',
	})

	-- EditorConfig support
	local disabled_editorconfig = functions.is_plugin_disabled('editorconfig')
	use({
		'editorconfig/editorconfig-vim',
		disable = disabled_editorconfig,
		event = 'TabNewEntered',
	})

	-- Comments
	-- can be disabled to use your own comments plugin
	local disabled_kommentary = functions.is_plugin_disabled('kommentary')
	use({
		'b3nj5m1n/kommentary',
		disable = disabled_kommentary,
		event = 'BufWinEnter',
	})

	-----[[-------------]]-----
	---     Web Related     ---
	-----]]-------------[[-----
	-- Fastest colorizer without external dependencies!
	local disabled_colorizer = functions.is_plugin_disabled('colorizer')
	use({
		'norcalli/nvim-colorizer.lua',
		config = require('doom.modules.config.doom-colorizer'),
		disable = disabled_colorizer,
		event = 'ColorScheme',
	})

	-- HTTP Client support
	-- Depends on bayne/dot-http to work!
	local disabled_restclient = functions.is_plugin_disabled('restclient')
	use({
		'NTBBloodbath/rest.nvim',
		requires = 'plenary.nvim',
		config = function()
			require('rest-nvim').setup()
		end,
		disable = disabled_restclient,
		event = 'BufEnter',
	})

	local disabled_range_highlight = functions.is_plugin_disabled(
		'range-highlight'
	)
	use({
		'winston0410/range-highlight.nvim',
		requires = {
			{ 'winston0410/cmd-parser.nvim', opt = true, module = 'cmd-parser' },
		},
		config = function()
			require('range-highlight').setup()
		end,
		disable = disabled_range_highlight,
		event = 'BufRead',
	})

	-----[[----------------]]-----
	---     Custom Plugins     ---
	-----]]----------------[[-----
	-- If there are custom plugins then also require them
	local custom_plugins = dofile(utils.doom_root .. '/plugins.lua')
	for _, plug in pairs(custom_plugins) do
		packer.use(plug)
	end
end)
