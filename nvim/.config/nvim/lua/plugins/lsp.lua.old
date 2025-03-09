return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"VonHeikemen/lsp-zero.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lua",
		"L3MON4D3/LuaSnip",
		"marilari88/twoslash-queries.nvim",
		"j-hui/fidget.nvim",
		"folke/lazydev.nvim",
	},
	config = function()
		local lsp_zero = require("lsp-zero")
		-- Reserve a space in the gutter
		-- This will avoid an annoying layout shift in the screen
		vim.opt.signcolumn = "yes"

		-- Add cmp_nvim_lsp capabilities settings to lspconfig
		-- This should be executed before you configure any language server
		local lspconfig_defaults = require("lspconfig").util.default_config
		lspconfig_defaults.capabilities = vim.tbl_deep_extend(
			"force",
			lspconfig_defaults.capabilities,
			require("cmp_nvim_lsp").default_capabilities()
		)

		-- This is where you enable features that only work
		-- if there is a language server active in the file
		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP actions",
			callback = function(event)
				local opts = { buffer = event.buf }

				-- vim.keymap.set("n", "gd", function()
				-- 	vim.lsp.buf.definition({
				-- 		on_list = on_list,
				-- 	})
				-- end, bufopts)
				--
				-- vim.keymap.set("n", "gr", function()
				-- 	vim.lsp.buf.references({
				-- 		on_list = on_list,
				-- 	})
				-- end, bufopts)

				local function on_list(options)
					vim.fn.setqflist({}, " ", options)
				end

				vim.keymap.set("n", "gD", function()
					vim.lsp.buf.declaration({
						on_list = on_list,
					})
				end, opts)

				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

				vim.keymap.set("n", "<leader>vd", function()
					vim.diagnostic.open_float()
				end, opts)

				-- Replaced diagnostics in quickfix list with trouble @SEE: "folke/trouble.nvim"
				vim.keymap.set("n", "]d", function()
					vim.diagnostic.goto_next()
				end)
				vim.keymap.set("n", "[d", function()
					vim.diagnostic.goto_prev()
				end)

				-- Replaced with inc-rename @SEE: "smjonas/inc-rename.nvim"
				-- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)

				vim.keymap.set("n", "<space>vca", function()
					vim.lsp.buf.code_action()
				end, opts)

				vim.keymap.set("n", "<space>f", function()
					vim.lsp.buf.format({ async = true })
				end, opts)

				vim.keymap.set("i", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, opts)
			end,
		})

		require("fidget").setup({})
		require("mason").setup()

		local capabilities = lspconfig_defaults.capabilities

		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"volar",
				"html",
				"tailwindcss",
				"marksman",
				"eslint",
				"emmet_language_server",
			},
			handlers = {
				lsp_zero.default_setup,
				ts_ls = function()
					local mason_registry = require("mason-registry")
					local vue_language_server_path = mason_registry
						.get_package("vue-language-server")
						:get_install_path() .. "/node_modules/@vue/language-server"

					local lspconfig = require("lspconfig")

					require("lspconfig").ts_ls.setup({
						-- NOTE: Pour activer le mode hybride, changez HybrideMode à true ci-dessus et décommentez le bloc de types de fichiers suivant.
						-- filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
						on_attach = function(client, bufnr)
							require("twoslash-queries").attach(client, bufnr)
						end,
						init_options = {
							plugins = {
								{
									name = "@vue/typescript-plugin",
									location = vue_language_server_path,
									languages = { "vue" },
								},
							},
						},
						capabilities = capabilities,
						filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
						settings = {
							typescript = {
								tsserver = {
									useSyntaxServer = false,
								},
								inlayHints = {
									includeInlayParameterNameHints = "all",
									includeInlayParameterNameHintsWhenArgumentMatchesName = true,
									includeInlayFunctionParameterTypeHints = true,
									includeInlayVariableTypeHints = true,
									includeInlayVariableTypeHintsWhenTypeMatchesName = true,
									includeInlayPropertyDeclarationTypeHints = true,
									includeInlayFunctionLikeReturnTypeHints = true,
									includeInlayEnumMemberValueHints = true,
								},
							},
						},
					})
				end,
				volar = function()
					require("lspconfig").eslint.setup({
						root_dir = require("lspconfig").util.root_pattern(
							".eslintrc",
							".eslintrc.js",
							".eslintrc.cjs",
							".eslintrc.yaml",
							".eslintrc.yml",
							".eslintrc.json",
							"package.json"
						),
					})

					require("lspconfig").volar.setup({
						on_attach = function(client, bufnr)
							require("twoslash-queries").attach(client, bufnr)
						end,
						capabilities = capabilities,
					})
				end,
				lua_ls = function()
					local lua_opts = lsp_zero.nvim_lua_ls()

					require("lspconfig")["lua_ls"].setup(vim.tbl_deep_extend("force", lua_opts, {
						capabilities = capabilities,
						settings = {
							Lua = {
								completion = {
									callSnippet = "Replace",
								},
							},
						},
					}))
				end,
				emmet_language_server = function()
					require("lspconfig")["emmet_language_server"].setup({
						capabilities = capabilities,
						filetypes = { "html", "typescriptreact", "javascriptreact", "css", "vue" },
						init_options = {
							html = {
								options = {
									["bem.enabled"] = true,
								},
							},
						},
					})
				end,
				-- ruby_lsp = function()
				-- 	require("lspconfig")["ruby_lsp"].setup({
				-- 		capabilities = capabilities,
				-- 		filetypes = { "ruby", "eruby" },
				-- 		init_options = {
				-- 			formatter = "standard",
				-- 			linters = { "standard" },
				-- 		},
				-- 	})
				-- end,
			},
		})

		local cmp = require("cmp")
		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			sources = {
				{ name = "path" },
				{ name = "nvim_lsp" },
				{ name = "nvim_lua" },
				{ name = "luasnip", keyword_length = 2 },
				{ name = "buffer", keyword_length = 3 },
			},
			formatting = lsp_zero.cmp_format({ async = true }),
			mapping = cmp.mapping.preset.insert({
				["<Enter>"] = cmp.mapping.confirm({ select = true }),
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
		})
	end,
}
