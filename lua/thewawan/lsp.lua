require'lspinstall'.setup() -- important

local function on_attach()
    -- TODO: TJ told me to do this and I should do it because he is Telescopic
    -- "Big Tech" "Cash Money" Johnson
end

--ts support
--https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#tsserver

require'lspconfig'.tsserver.setup{ on_attach=on_attach }
