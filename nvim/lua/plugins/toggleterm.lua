-- Better terminal - Toggleterm for floating terminals
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  lazy = false,
  opts = {
    open_mapping = [[<c-\>]],
    direction = 'horizontal',
    size = 20,
    start_in_insert = false,
    on_open = function()
      vim.opt_local.cursorline = false
    end,
  },
  keys = {
    { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Toggle floating terminal' },
  },
}