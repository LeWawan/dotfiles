-- stylua: ignore
if true then return {} end

return {
  {
    "akinsho/bufferline.nvim",
    keys = {
      { "<Tab>", "BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },
}
