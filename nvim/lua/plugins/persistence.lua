return {
  'folke/persistence.nvim',
  lazy = false,
  config = function()
    require('persistence').setup()

    -- Close Neo-tree before saving and after loading sessions
    local function close_neotree()
      vim.cmd("silent! Neotree close")
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = { "PersistenceSavePre", "PersistenceLoadPost" },
      callback = close_neotree,
    })

    -- Auto restore session on startup
    local argc = vim.fn.argc(-1)
    if argc == 0 then
      vim.schedule(function()
        require('persistence').load()
      end)
    end
  end,
  keys = {
    { '<leader>Sr', function() require('persistence').load() end, desc = 'Restore Session' },
    { '<leader>Sl', function() require('persistence').load({ last = true }) end, desc = 'Restore Last Session' },
    { '<leader>Sd', function() require('persistence').stop() end, desc = "Don't Save Current Session" },
  },
}