local M = {}

function M.cowboy()
  --@type table?
  local id
  local ok = true

  for _, key in ipairs({ "h", "j", "k", "l", "+", "-" }) do
    local count = 0
    local max_count = 10
    local timer = assert(vim.loop.new_timer())
    local map = key

    vim.keymap.set("n", key, function()
      if vim.v.count > 0 then
        count = 0
      end
      if count >= max_count then
        ok, id = pcall(vim.notify, "Hold it Cowboy!", vim.log.levels.WARN, {
          icon = "🤠",
          replace = id,
          keep = function()
            return count >= max_count
          end,
        })
        if not ok then
          id = nil
          return map
        end
      else
        count = count + 1
        timer:start(2000, 0, function()
          count = 0
        end)
        return map
      end
    end, { expr = true, silent = true })
  end
end

return M
