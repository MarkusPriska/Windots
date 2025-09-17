return {
  "okuuva/auto-save.nvim",
  version = '^1.0.0',
  event = { "InsertLeave", "TextChanged" },
  opts = {
    enabled = true,
    trigger_events = {
      immediate_save = { "BufLeave", "FocusLost", "QuitPre", "VimSuspend" },
      defer_save = { "InsertLeave", "TextChanged" },
      cancel_deferred_save = { "InsertEnter" },
    },
    condition = function(buf)
      local fn = vim.fn
      local filetype = fn.getbufvar(buf, "&filetype")
      
      -- Don't autosave for certain filetypes
      local excluded_filetypes = { "oil", "neo-tree", "trouble", "lazy", "mason" }
      for _, ft in ipairs(excluded_filetypes) do
        if filetype == ft then
          return false
        end
      end
      
      -- Don't save if buffer is not modified or is readonly
      return fn.getbufvar(buf, "&modified") == 1 and fn.getbufvar(buf, "&readonly") == 0
    end,
    write_all_buffers = false, -- Only save current buffer
    debounce_delay = 1000, -- 1 second delay
    debug = false,
  },
}