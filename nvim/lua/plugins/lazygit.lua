return {
  'kdheepak/lazygit.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    { '<leader>gf', '<cmd>LazyGitFilter<cr>', desc = 'LazyGit Filter' },
    { '<leader>gc', '<cmd>LazyGitFilterCurrentFile<cr>', desc = 'LazyGit Current File' },
    { '<leader>gr', function() 
        local git_root = vim.fn.system('git -C ' .. vim.fn.expand('%:p:h') .. ' rev-parse --show-toplevel 2>/dev/null'):gsub('\n', '')
        if vim.v.shell_error == 0 then
          require('lazygit').lazygit(git_root)
        else
          vim.cmd('LazyGit')
        end
      end, desc = 'LazyGit for current file repo' },
  },
}