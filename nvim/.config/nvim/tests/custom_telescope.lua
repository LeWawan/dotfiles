local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local builtin = require 'telescope.builtin'

local colors = function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "colors",
    finder = finders.new_table {
      results = vim.api.nvim_list_bufs(),
      entry_maker = function(entry)
        return {
          value = entry,
          display = function()
            local data = vim.api.nvim_buf_get_lines(entry, 0, 1, false)
            local lineString
            if data then
              for _, line in ipairs(data) do
                lineString = line
              end
            end

            local bufName = vim.api.nvim_buf_get_name(entry) or 'nul'
            local displayName = tostring(bufName)

            return tostring(entry) .. ' - ' .. displayName
          end,
          ordinal = entry,
        }
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.api.nvim_set_current_buf(selection.value)
        -- vim.api.nvim_put({ tostring(selection.value) }, "", false, true)
      end)
      return true
    end,
  }):find()
end

-- to execute the function
colors(require("telescope.themes").get_dropdown{})

