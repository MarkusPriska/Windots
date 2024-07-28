return {
    {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<tab>",
          clear_suggestion = "<A-c>",
          accept_word = "<A-w>",
        },
      })
    end,
    },
    {
      "hrsh7th/nvim-cmp",
      keys = {
        { "<tab>", false, mode = { "i", "s" } },
        { "<s-tab>", false, mode = { "i", "s" } },
      },
    },
  }
  