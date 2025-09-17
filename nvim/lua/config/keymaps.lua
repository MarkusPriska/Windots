-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')


-- Quit shortcuts
vim.keymap.set('n', '<leader>qq', '<cmd>qa<CR>', { desc = '[Q]uit all' })
vim.keymap.set('n', '<leader>qw', '<cmd>wqa<CR>', { desc = '[Q]uit all and [W]rite' })
vim.keymap.set('n', '<leader>qf', '<cmd>qa!<CR>', { desc = '[Q]uit all [F]orce' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- K to toggle hover popup
vim.keymap.set('n', 'K', function()
  local windows = vim.api.nvim_list_wins()
  for _, win in ipairs(windows) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= '' then -- It's a floating window
      vim.api.nvim_win_close(win, true)
      return
    end
  end
  vim.lsp.buf.hover()
end, { desc = 'Toggle Hover' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', function()
  -- Check if hover popup is open
  local windows = vim.api.nvim_list_wins()
  for _, win in ipairs(windows) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= '' then -- Floating window exists
      vim.lsp.buf.hover() -- Enter it
      return
    end
  end
  -- Normal window navigation
  vim.cmd('wincmd j')
end, { desc = 'Move focus down or enter hover' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Window resizing with arrow keys
vim.keymap.set('n', '<C-Up>', '<C-w>+', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', '<C-w>-', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', '<C-w><', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', '<C-w>>', { desc = 'Increase window width' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- Toggle GitHub Copilot
vim.keymap.set('n', '<leader>tc', function()
  if vim.fn['copilot#Enabled']() == 1 then
    vim.cmd('Copilot disable')
    print('Copilot disabled')
  else
    vim.cmd('Copilot enable')
    print('Copilot enabled')
  end
end, { desc = '[T]oggle [C]opilot' })

-- Move lines/selections up and down (ThePrimeagen style in visual, Alt for other modes)
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
vim.keymap.set('n', '<M-j>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<M-k>', ':m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('i', '<M-j>', '<Esc>:m .+1<CR>==gi', { desc = 'Move line down' })
vim.keymap.set('i', '<M-k>', '<Esc>:m .-2<CR>==gi', { desc = 'Move line up' })

-- ThePrimeagen's centering remaps
-- Center screen when moving half page
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up and center" })

-- Center when searching
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- Keep cursor centered when joining lines
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Quickfix navigation with centering (using leader since C-j/k are taken for window nav)
vim.keymap.set("n", "<leader>cn", "<cmd>cnext<CR>zz", { desc = "Next quickfix and center" })
vim.keymap.set("n", "<leader>cp", "<cmd>cprev<CR>zz", { desc = "Previous quickfix and center" })
vim.keymap.set("n", "<leader>ln", "<cmd>lnext<CR>zz", { desc = "Next location list and center" })
vim.keymap.set("n", "<leader>lp", "<cmd>lprev<CR>zz", { desc = "Previous location list and center" })

