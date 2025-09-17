return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  event = 'VimEnter',
  init = function() vim.g.barbar_auto_setup = false end,
  opts = {
    -- Enable/disable animations
    animation = true,
    
    -- Enable/disable auto-hiding the tab bar when there is a single buffer
    auto_hide = false,
    
    -- Enable/disable current/total tabpages indicator (top right corner)
    tabpages = true,
    
    -- Enables/disable clickable tabs
    clickable = true,
    
    -- Excludes buffers from the tabline
    exclude_ft = {'javascript'},
    exclude_name = {'package.json'},
    
    -- A buffer to this direction will be focused (if it exists) when closing the current buffer
    focus_on_close = 'left',
    
    -- Hide inactive buffers and file extensions
    hide = {extensions = false, inactive = false},
    
    -- Disable highlighting alternate buffers
    highlight_alternate = false,
    
    -- Disable highlighting file icons in inactive buffers
    highlight_inactive_file_icons = false,
    
    -- Enable highlighting visible buffers
    highlight_visible = true,
    
    icons = {
      -- Configure the base icons on the bufferline
      buffer_index = false,
      buffer_number = false,
      button = '',
      -- Enables / disables diagnostic symbols
      diagnostics = {
        [vim.diagnostic.severity.ERROR] = {enabled = false},
        [vim.diagnostic.severity.WARN] = {enabled = false},
        [vim.diagnostic.severity.INFO] = {enabled = false},
        [vim.diagnostic.severity.HINT] = {enabled = false},
      },
      gitsigns = {
        added = {enabled = false},
        changed = {enabled = false},
        deleted = {enabled = false},
      },
      filetype = {
        -- Sets the icon's highlight group
        custom_colors = false,
        -- Requires `nvim-web-devicons`
        enabled = true,
      },
      separator = {left = '▎', right = ''},
      -- If true, add an additional separator at the end of the buffer list
      separator_at_end = true,
      -- Configure the icons on the bufferline when modified or pinned
      modified = {button = '●'},
      pinned = {button = '', filename = true},
      
      -- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'
      preset = 'default',
      
      -- Configure the icons on the bufferline based on the visibility of a buffer
      alternate = {filetype = {enabled = false}},
      current = {buffer_index = false},
      inactive = {button = '×'},
      visible = {modified = {buffer_number = false}},
    },
    
    -- If set, the letters for each buffer in buffer-pick mode will be
    -- assigned based on their name. Otherwise or in case all letters are
    -- already assigned, the behavior is to assign letters in order of
   -- usability (see order below)
    letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
    
    -- New buffer letters are assigned in this order. This order is
    -- optimal for the qwerty keyboard layout but might need adjustment
    -- for other layouts.
    letter_order = 'etovxqpdygfblzhckisuran',
    
    -- Sets the maximum padding width with which to surround each tab
    maximum_padding = 4,
    
    -- Sets the minimum padding width with which to surround each tab
    minimum_padding = 2,
    
    -- Sets the maximum buffer name length
    maximum_length = 30,
    
    -- Sets the minimum buffer name length
    minimum_length = 0,
    
    -- If set, the tab will display the number of windows in the buffer
    no_name_title = nil,
  },
  keys = {
    -- Move to previous/next
    { '<A-,>', '<Cmd>BufferPrevious<CR>', desc = 'Previous buffer' },
    { '<A-.>', '<Cmd>BufferNext<CR>', desc = 'Next buffer' },
    -- Re-order to previous/next
    { '<A-<>', '<Cmd>BufferMovePrevious<CR>', desc = 'Move buffer left' },
    { '<A->>', '<Cmd>BufferMoveNext<CR>', desc = 'Move buffer right' },
    -- Goto buffer in position...
    { '<A-1>', '<Cmd>BufferGoto 1<CR>', desc = 'Go to buffer 1' },
    { '<A-2>', '<Cmd>BufferGoto 2<CR>', desc = 'Go to buffer 2' },
    { '<A-3>', '<Cmd>BufferGoto 3<CR>', desc = 'Go to buffer 3' },
    { '<A-4>', '<Cmd>BufferGoto 4<CR>', desc = 'Go to buffer 4' },
    { '<A-5>', '<Cmd>BufferGoto 5<CR>', desc = 'Go to buffer 5' },
    { '<A-6>', '<Cmd>BufferGoto 6<CR>', desc = 'Go to buffer 6' },
    { '<A-7>', '<Cmd>BufferGoto 7<CR>', desc = 'Go to buffer 7' },
    { '<A-8>', '<Cmd>BufferGoto 8<CR>', desc = 'Go to buffer 8' },
    { '<A-9>', '<Cmd>BufferGoto 9<CR>', desc = 'Go to buffer 9' },
    { '<A-0>', '<Cmd>BufferLast<CR>', desc = 'Go to last buffer' },
    -- Pin/unpin buffer
    { '<A-p>', '<Cmd>BufferPin<CR>', desc = 'Pin buffer' },
    -- Close buffer
    { '<A-c>', '<Cmd>BufferClose<CR>', desc = 'Close buffer' },
    -- Wipeout buffer
    { '<A-C>', '<Cmd>BufferWipeout<CR>', desc = 'Wipeout buffer' },
    -- Close commands
    { '<A-C-p>', '<Cmd>BufferCloseAllButPinned<CR>', desc = 'Close all but pinned' },
    { '<A-C-r>', '<Cmd>BufferCloseAllButCurrent<CR>', desc = 'Close all but current' },
    { '<A-C-l>', '<Cmd>BufferCloseBuffersLeft<CR>', desc = 'Close buffers to the left' },
    { '<A-C-h>', '<Cmd>BufferCloseBuffersRight<CR>', desc = 'Close buffers to the right' },
    -- Magic buffer-picking mode
    { '<C-p>', '<Cmd>BufferPick<CR>', desc = 'Pick buffer' },
  },
}
