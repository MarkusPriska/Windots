return {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufRead",
    config = function()
        require("treesitter-context").setup({
            enable = true,
            max_lines = 0,
            trim_scope = "outer",
            ignore = {
                "comment",
            },
            patterns = {
                default = {
                    "class",
                    "function",
                    "method",
                },
            },
        })
    end,
}
