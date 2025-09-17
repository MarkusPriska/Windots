return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope.nvim",
  },
  ft = "python",
  keys = {
    { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
  },
  opts = {
    -- Use default search configurations which will find venvs in:
    -- Current directory, parent directories, and common subdirectories
    search = {
      -- Search for .venv in current directory and subdirectories
      cwd_venv = {
        command = "fd -HI -a -L --max-depth 4 -E .git 'bin/python$' $CWD",
      },
    },
    options = {
      enable_default_searches = true, -- Keeps all default search methods
      enable_cached_venvs = true,     -- Remember previously selected venvs
      cached_venv_automatic_activation = true, -- Auto-activate cached venvs
      activate_venv_in_terminal = true,
      set_environment_variables = true,
      notify_user_on_venv_activation = true,
      -- Disable automatic LSP management to preserve our settings
      on_venv_activate_callback = nil,
    },
    -- Disable all automatic LSP hooks
    hooks = {},
  },
}