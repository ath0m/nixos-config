-- return {}
local recent_messages = {}

return {
  "rcarriga/nvim-notify",
  opts = {
    on_open = function(win)
      local win_buff = vim.api.nvim_win_get_buf(win)
      local msg = vim.api.nvim_buf_get_lines(win_buff, 0, -1, false)[1]
      local now = os.time() -- seconds since epoch
      for i_msg, i_timestamp in pairs(recent_messages) do
        if now - i_timestamp > 5 then
          recent_messages[i_msg] = nil
        end
      end
      if recent_messages[msg] ~= nil and now - recent_messages[msg] < 5 then
        vim.api.nvim_win_close(win, true)
        recent_messages[msg] = now
      else
        recent_messages[msg] = now
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end
    end,
  },
}
