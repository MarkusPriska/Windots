return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "VeryLazy",
    config = function()
        require("ibl").setup({
            scope = {
                show_start = false,
            },
            indent = {
                smart_indent_cap = true,
            },
        })
    end,
}
