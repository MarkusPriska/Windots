return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup { use_icons = vim.g.have_nerd_font }

    -- Override filename section for active windows
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_filename = function(args)
      return vim.fn.fnamemodify(vim.fn.expand('%'), ':t')
    end

    -- Store original fileinfo function
    local original_fileinfo = statusline.section_fileinfo

    -- Override fileinfo section to add Copilot indicator
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_fileinfo = function(args)
      local copilot_icon = ''
      if vim.fn.exists('*copilot#Enabled') == 1 and vim.fn['copilot#Enabled']() == 1 then
        copilot_icon = '🤖 '
      end
      -- Get original fileinfo (includes icon and filetype)
      local original = original_fileinfo(args)
      return copilot_icon .. original
    end

    -- Set up autocommands to handle inactive window statuslines
    vim.api.nvim_create_autocmd({ 'WinLeave' }, {
      callback = function()
        vim.wo.statusline = '%t'
      end
    })

    vim.api.nvim_create_autocmd({ 'WinEnter' }, {
      callback = function()
        vim.wo.statusline = ''  -- Use default (mini.statusline)
      end
    })


    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}