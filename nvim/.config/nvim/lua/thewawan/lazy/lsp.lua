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
		"rafamadriz/friendly-snippets",
		"marilari88/twoslash-queries.nvim",
		"folke/neodev.nvim",
		"j-hui/fidget.nvim",
	},
	config = function()
		local lsp_zero = require("lsp-zero")

		lsp_zero.on_attach(function(client, bufnr)
			require("twoslash-queries").attach(client, bufnr)

			local bufopts = { buffer = bufnr, remap = false }

			local function on_list(options)
				vim.fn.setqflist({}, " ", options)
				require("trouble").open("quickfix")
			end

			-- Replaced by telescope...
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

			vim.keymap.set("n", "gD", function()
				vim.lsp.buf.declaration({
					on_list = on_list,
				})
			end, bufopts)

			vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)

			vim.keymap.set("n", "<leader>vd", function()
				vim.diagnostic.open_float()
			end, bufopts)

			-- Replaced diagnostics in quickfix list with trouble @SEE: "folke/trouble.nvim"
			vim.keymap.set("n", "]d", function()
				vim.diagnostic.goto_next()
			end)
			vim.keymap.set("n", "[d", function()
				vim.diagnostic.goto_prev()
			end)

			-- Replaced with inc-rename @SEE: "smjonas/inc-rename.nvim"
			-- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)

			vim.keymap.set("n", "<space>vca", function()
				vim.lsp.buf.code_action()
			end, bufopts)
			vim.keymap.set("n", "<space>f", function()
				vim.lsp.buf.format({ async = true })
			end, bufopts)

			vim.keymap.set("i", "<C-h>", function()
				vim.lsp.buf.signature_help()
			end, bufopts)
		end)

		require("fidget").setup({})
		require("mason").setup()
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
				"intelephense",
			},
			handlers = {
				lsp_zero.default_setup,
				volar = function()
					local util = require("lspconfig.util")
					local function get_typescript_server_path(root_dir)
						local global_ts = "/Users/erwan.kreutz/Library/pnpm/global/5/node_modules/typescript/lib"
						-- Alternative location if installed as root:
						-- local global_ts = '/usr/local/lib/node_modules/typescript/lib'
						local found_ts = ""
						local function check_dir(path)
							found_ts = util.path.join(path, "node_modules", "typescript", "lib")
							if util.path.exists(found_ts) then
								return path
							end
						end
						if util.search_ancestors(root_dir, check_dir) then
							return found_ts
						else
							return global_ts
						end
					end

					require("lspconfig").eslint.setup({
						root_dir = util.root_pattern(
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
						filetypes = { "vue", "javascript", "typescript", "typescriptreact" },
						init_options = {
							vue = {
								hybridMode = false,
							},
						},
					})

					-- Multi server setup ( Needed ? )
					-- local lspconfig_util = require("lspconfig.util")
					-- local lspconfig_configs = require("lspconfig.configs")

					-- local function on_new_config(new_config, new_root_dir)
					-- 	local function get_typescript_server_path(root_dir)
					-- 		local global_ts = "/home/[yourusernamehere]/.npm/lib/node_modules/typescript/lib"
					-- 		-- Alternative location if installed as root:
					-- 		-- local global_ts = '/usr/local/lib/node_modules/typescript/lib'
					-- 		local found_ts = ""
					-- 		local function check_dir(path)
					-- 			found_ts = lspconfig_util.path.join(path, "node_modules", "typescript", "lib")
					-- 			if lspconfig_util.path.exists(found_ts) then
					-- 				return path
					-- 			end
					-- 		end
					-- 		if lspconfig_util.search_ancestors(root_dir, check_dir) then
					-- 			return found_ts
					-- 		else
					-- 			return global_ts
					-- 		end
					-- 	end
					--
					-- 	if
					-- 		new_config.init_options
					-- 		and new_config.init_options.typescript
					-- 		and new_config.init_options.typescript.tsdk == ""
					-- 	then
					-- 		new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
					-- 	end
					-- end
					--

					-- local volar_cmd = { "vue-language-server", "--stdio" }
					-- local volar_root_dir = lspconfig_util.root_pattern("package.json")

					-- lspconfig_configs.volar_api = {
					-- 	default_config = {
					-- 		cmd = volar_cmd,
					-- 		root_dir = volar_root_dir,
					-- 		on_new_config = on_new_config,
					-- 		filetypes = { "vue", "javascript", "typescript", "typescriptreact" },
					-- 		init_options = {
					-- 			typescript = {
					-- 				tsdk = "",
					-- 			},
					-- 			languageFeatures = {
					-- 				implementation = true, -- new in @volar/vue-language-server v0.33
					-- 				references = true,
					-- 				definition = true,
					-- 				typeDefinition = true,
					-- 				callHierarchy = true,
					-- 				hover = true,
					-- 				rename = true,
					-- 				renameFileRefactoring = true,
					-- 				signatureHelp = true,
					-- 				codeAction = true,
					-- 				workspaceSymbol = true,
					-- 				completion = {
					-- 					defaultTagNameCase = "both",
					-- 					defaultAttrNameCase = "kebabCase",
					-- 					getDocumentNameCasesRequest = false,
					-- 					getDocumentSelectionRequest = false,
					-- 				},
					-- 			},
					-- 		},
					-- 	},
					-- }
					-- require("lspconfig").volar_api.setup({})
					--
					-- lspconfig_configs.volar_doc = {
					-- 	default_config = {
					-- 		cmd = volar_cmd,
					-- 		root_dir = volar_root_dir,
					-- 		on_new_config = on_new_config,
					--
					-- 		filetypes = { "vue" },
					-- 		-- If you want to use Volar's Take Over Mode (if you know, you know):
					-- 		--filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
					-- 		init_options = {
					-- 			typescript = {
					-- 				tsdk = "",
					-- 			},
					-- 			languageFeatures = {
					-- 				implementation = true, -- new in @volar/vue-language-server v0.33
					-- 				documentHighlight = true,
					-- 				documentLink = true,
					-- 				codeLens = { showReferencesNotification = true },
					-- 				-- not supported - https://github.com/neovim/neovim/pull/15723
					-- 				semanticTokens = false,
					-- 				diagnostics = true,
					-- 				schemaRequestService = true,
					-- 			},
					-- 		},
					-- 	},
					-- }
					-- require("lspconfig").volar_doc.setup({})
					--
					-- lspconfig_configs.volar_html = {
					-- 	default_config = {
					-- 		cmd = volar_cmd,
					-- 		root_dir = volar_root_dir,
					-- 		on_new_config = on_new_config,
					--
					-- 		filetypes = { "vue" },
					-- 		-- If you want to use Volar's Take Over Mode (if you know, you know), intentionally no 'json':
					-- 		--filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
					-- 		init_options = {
					-- 			typescript = {
					-- 				tsdk = "",
					-- 			},
					-- 			documentFeatures = {
					-- 				selectionRange = true,
					-- 				foldingRange = true,
					-- 				linkedEditingRange = true,
					-- 				documentSymbol = true,
					-- 				-- not supported - https://github.com/neovim/neovim/pull/13654
					-- 				documentColor = false,
					-- 				documentFormatting = {
					-- 					defaultPrintWidth = 100,
					-- 				},
					-- 			},
					-- 		},
					-- 	},
					-- }
					-- require("lspconfig").volar_html.setup({})
				end,
				lua_ls = function()
					require("neodev").setup()

					local lua_opts = lsp_zero.nvim_lua_ls()

					require("lspconfig")["lua_ls"].setup(vim.tbl_deep_extend("force", lua_opts, {
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
			formatting = lsp_zero.cmp_format(),
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
-- Mappings
-- vim.cmd('set completeopt=menu,menuone,noselect')
--
-- local opts = { noremap = true, silent = true }
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
--
-- -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
-- -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
-- --
-- -- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
--
-- ---@diagnostic disable-next-line: unused-local
-- local on_attach = function(client, bufnr)
--   -- attach twoslash queries
--   require("twoslash-queries")
--     -- .setup({
--     --   multi_line = true,
--     -- })
--     .attach(client, bufnr)
--
--   -- Enable completion triggered by <c-x><c-o>
--   vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
--
--   -- Mappings.
--   -- See `:help vim.lsp.*` for documentation on any of the below functions
--   local bufopts = { noremap = true, silent = true, buffer = bufnr }
--
--   -- Goto keymaps
--   vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
--   vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
--   vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
--
--   -- Show keymaps
--   vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
--   vim.keymap.set('n', '<space>k', vim.lsp.buf.signature_help, bufopts)
--
--   -- Workspace keymaps
--   vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
--   vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
--   vim.keymap.set('n', '<space>wl', function()
--     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--   end, bufopts)
--   vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
--   vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
--   vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action, bufopts)
--   vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
--   vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
-- end
--
-- local flags = {
--   -- This is the default in Nvim 0.7+
--   debounce_text_changes = 150,
-- }
--
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
--
-- local function config(_config)
--   return vim.tbl_deep_extend('force', {
--     capabilities = capabilities,
--     on_attach = on_attach,
--     flags = flags
--   }, _config or {})
-- end
--
-- local cmp = require('cmp')
-- local lspkind = require('lspkind')
--
-- local source_mapping = {
--   buffer = '[Buffer]',
--   nvim_lsp = '[Lsp]',
--   nvim_lua = '[Lua]',
--   vsnip = '[Vsnip]',
--   cmp = '[Cmp]',
--   path = '[Path]'
-- }
--
-- cmp.setup({
--   snippet = {
--     expand = function(args)
--       vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
--     end,
--   },
--   mapping = cmp.mapping.preset.insert({
--     ['<Enter>'] = cmp.mapping.confirm({ select = true }),
--     ["<C-u>"] = cmp.mapping.scroll_docs(-4),
--     ["<C-d>"] = cmp.mapping.scroll_docs(4),
--     ["<C-Space>"] = cmp.mapping.complete(),
--   }),
--   formatting = {
--     format = function(entry, vim_item)
--       vim_item.kind = lspkind.presets.default[vim_item.kind]
--       local menu = source_mapping[entry.source.name]
--       vim_item.menu = menu
--       return vim_item
--     end,
--   },
--   sources = cmp.config.sources({
--       { name = 'vsnip' },
--       { name = 'nvim_lsp' },
--     },
--     {
--       { name = 'buffer' }
--     })
-- })
--
-- -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
-- require("neodev").setup()
--
-- local lspconfig = require('lspconfig')
--
-- require('mason').setup()
--
-- local basic_servers = {
--   'astro',
--   'html',
--   'tailwindcss',
--   'marksman',
--   'intelephense',
--   'eslint',
--   'prismals',
-- }
--
-- require('mason-lspconfig').setup({
--   ensure_installed = {
--     'lua_ls',
--     'rust_analyzer',
--     'tsserver',
--     'volar',
--     'prismals',
--     unpack(basic_servers),
--   }
-- })
--
-- for _key, value in pairs(basic_servers) do
--   lspconfig[value].setup(config())
-- end
--
-- lspconfig.lua_ls.setup(config({
--   settings = {
--     Lua = {
--       completion = {
--         callSnippet = "Replace"
--       }
--     }
--   }
-- }))
--
-- -- Typescript config
-- lspconfig.tsserver.setup(config())
--
-- -- Vuejs config
-- lspconfig.volar.setup(config({
--   filetypes = { 'vue', 'javascript', 'typescript', 'typescriptreact' },
--   init_options = {
--     typescript = {
--       -- serverPath = '~/.nvm/versions/node/v18.12.0/lib/node_modules/npm/node_modules/typescript/lib/tsserverlibrary.js',
--       tsdk = '/home/wawan/.local/share/fnm/node-versions/v18.16.0/installation/lib/node_modules/typescript/lib'
--       -- Alternative location if installed as root:
--       -- serverPath = '/usr/local/lib/node_modules/typescript/lib/tsserverlibrary.js'
--     }
--   },
--   settings = {
--     format = {
--       semicolons = 'remove'
--     }
--   }
-- }))
--
-- -- Rust config
-- lspconfig.rust_analyzer.setup(config({
--   cmd = {
--     "rustup", "run", "stable", "rust-analyzer"
--   }
-- }))
--
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- lspconfig.emmet_ls.setup(config({
--   filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' },
--   init_options = {
--     html = {
--       options = {
--         ["bem.enabled"] = true,
--       },
--     },
--   }
-- }))
--
-- lspconfig.prettier.setup(config({
--   filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' },
-- }))
--
-- lspconfig.solidity.setup(config({
--   cmd = {'nomicfoundation-solidity-language-server', '--stdio'},
--   filetypes = { 'solidity' },
--   root_dir = lspconfig.util.find_git_ancestor,
--   single_file_support = true,
-- }))
--
-- lspconfig.gopls.setup(config({
--    settings = {
--     gopls = {
--       gofumpt = true
--     }
--   }
-- }))
--
-- lspconfig.solidity.setup(config({
--     cmd = {'nomicfoundation-solidity-language-server', '--stdio'},
--     filetypes = { 'solidity' },
--     root_dir = lspconfig.util.find_git_ancestor,
--     single_file_support = true,
-- }))
--
-- lspconfig.htmx.setup(config({
--   filetypes = { 'html' },
-- }))
