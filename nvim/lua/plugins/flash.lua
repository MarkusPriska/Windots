return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {
    search = {
      multi_window = false, -- Only search in current window
    },
  },
  keys = {
    { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
    { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
  },
}