return {
    "akinsho/toggleterm.nvim",
    keys = {
        { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal", mode = "n" },
        { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal", mode = "t" },
    },
    opts = {
        shade_terminals = true,
        direction = "horizontal",
        size = vim.o.lines * 0.3,
    },
}
