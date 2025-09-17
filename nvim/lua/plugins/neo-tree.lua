-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  config = function()
    require("neo-tree").setup({
      window = {
        position = "float",
        popup = {
          position = { col = "5%", row = "10%" },
          size = function(state)
            local root_name = vim.fn.fnamemodify(state.path, ":~")
            local root_len = string.len(root_name) + 4
            return {
              width = math.max(80, root_len),
              height = vim.o.lines - 6
            }
          end,
        },
        mappings = {
          ['\\'] = 'close_window',
          ['l'] = 'open',
          ['<esc>'] = 'close_window',
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      default_component_configs = {
        git_status = {
          symbols = {
            -- Change type
            added = "A",
            modified = "M",
            deleted = "D",
            renamed = "R",
            -- Status type
            untracked = "U",
            ignored = "!",
            unstaged = "M",
            staged = "A",
            conflict = "E",
          },
          align = "right",
        },
      },
    })

    -- Custom Git status colors to match VS Code
    vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { fg = "#6cbd8a" }) -- VS Code green
    vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = "#e0af68" })  -- Yellow like VS Code
    vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { fg = "#6cbd8a" })     -- Green for staged files
    vim.api.nvim_set_hl(0, "NeoTreeGitDeleted", { fg = "#f7768e" })   -- Red for deleted files
    vim.api.nvim_set_hl(0, "NeoTreeGitRenamed", { fg = "#7aa2f7" })   -- Blue for renamed files
    vim.api.nvim_set_hl(0, "NeoTreeGitIgnored", { fg = "#565f89" })   -- Gray for ignored files
    vim.api.nvim_set_hl(0, "NeoTreeGitConflict", { fg = "#f7768e" })  -- Red for conflicts
    vim.api.nvim_set_hl(0, "NeoTreeGitUnstaged", { fg = "#f7768e" })  -- Red for unstaged changes
  end,
}
