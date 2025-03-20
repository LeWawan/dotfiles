return {
	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {},
		event = "InsertEnter",
		config = function()
			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			local lsp_zero = require("lsp-zero")

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
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
			})
		end,
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		cmd = "LspInfo",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"VonHeikemen/lsp-zero.nvim",

			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",

			"marilari88/twoslash-queries.nvim",
		},
		init = function()
			-- Reserve a space in the gutter
			-- This will avoid an annoying layout shift in the screen
			vim.opt.signcolumn = "yes"
		end,
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"volar",
					"html",
					"tailwindcss",
					"marksman",
					"eslint",
					"emmet_language_server",
				},
			})

			local lsp_zero = require("lsp-zero")
			local lsp_defaults = require("lspconfig").util.default_config

			-- Add cmp_nvim_lsp capabilities settings to lspconfig
			-- This should be executed before you configure any language server
			lsp_defaults.capabilities =
				vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- LspAttach is where you enable features that only work
			-- if there is a language server active in the file
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }

					local function on_list(options)
						vim.fn.setqflist({}, " ", options)
					end

					vim.keymap.set("n", "K", function()
						vim.lsp.buf.hover()
					end, opts)
					vim.keymap.set("n", "gD", function()
						vim.lsp.buf.declaration({ on_list = on_list })
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

					vim.keymap.set("n", "<space>f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})

			-- These are just examples. Replace them with the language
			-- servers you have installed in your system
			require("lspconfig").volar.setup({
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
				init_options = {
					vue = {
						hybridMode = false,
					},
				},
				on_attach = function(client, bufnr)
					require("twoslash-queries").attach(client, bufnr)

          require("ts-error-translator").setup()
				end,
			})

			require("lspconfig").tailwindcss.setup({
				flags = {
					debounce_text_changes = 1000,
				},
			})

			require("lspconfig").eslint.setup({
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
				flags = {
					debounce_text_changes = 1000,
				},
			})

			-- Not today son :(
			-- require("lspconfig").oxlint.setup({
			-- 	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			-- 	cmd = { "oxlint", "--stdio" },
			-- 	debug = true,
			-- })

			require("lspconfig").emmet_language_server.setup({
				init_options = {
					html = {
						options = {
							["bem.enabled"] = true,
						},
					},
				},
			})

			local lua_opts = lsp_zero.nvim_lua_ls()
			require("lspconfig").lua_ls.setup(vim.tbl_deep_extend("force", lua_opts, {
				init_options = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			}))

			require("lspconfig").marksman.setup({})
			-- require("lspconfig").html.setup({})
		end,
	},
}
