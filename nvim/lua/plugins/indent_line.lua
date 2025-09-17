return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      local hooks = require 'ibl.hooks'
      -- Register highlight setup hook - this is the documented way
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#3d4048' })
        vim.api.nvim_set_hl(0, 'IblScope', { fg = '#636771' })
      end)

      require('ibl').setup {
        indent = { char = '│' },
        scope = {
          char = '│',
          show_start = false,
          show_end = false,
        },
      }
    end,
  },
}
