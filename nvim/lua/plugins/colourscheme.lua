return {
    {
        "navarasu/onedark.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            -- Initial setup for the onedark theme
            require("onedark").setup({
                style = "dark",  -- or other style you prefer
            })

            -- Retrieve colors from the theme
            local c = require("onedark.colors")

            -- Define custom highlights
            local custom_highlights = {
                NeoTreeWinSeparator  = { fg = c.none, bg = c.none },

                -- For barbar.nvim
                BufferOffset         = { bg = c.bg_d },

                -- For neo-tree.nvim
                -- NeoTreeCursorLine     = { bg = c.bg_d },

            }

            -- Reapply the theme with custom highlights
            require("onedark").setup({
                style = "dark",  -- Same style as before
                highlights = custom_highlights,  -- Apply custom highlights
            })

            -- Reapply colorscheme to reflect custom highlights
            vim.cmd("colorscheme onedark")
        end,
    },
}


