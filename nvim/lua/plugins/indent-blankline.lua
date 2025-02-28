return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "VeryLazy",

    config = function()
        require("ibl").setup({
            indent = {
                char = "▏",
            },
            scope = {
                show_start = false,
                show_end = false,
            },
        })
    end,
}
