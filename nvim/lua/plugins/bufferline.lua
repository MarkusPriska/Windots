return {
    "akinsho/bufferline.nvim",
    event = "BufRead",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("bufferline").setup({
            options = {

                -- numbers = "none",
                -- close_command = "Bdelete! %d",
                -- right_mouse_command = "Bdelete! %d",
                -- left_mouse_command = "buffer %d",
                -- middle_mouse_command = nil,
                --
                -- indicator = {
                --     style = "icon",
                --     icon = "", --'▎',
                --     buffer_close_icon = "HEJ",
                --     modified_icon = "●",
                --     close_icon = "HEJ",
                --     left_trunc_marker = "<-", --'',
                --     right_trunc_marker = "->", --'',
                -- },
                offsets = { { filetype = "neo-tree", text = "File Explorer", text_align = "center", separator = false } },

                separator_style = "slant",
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(count, level)
                    local icon = level:match("error") and "" or ""
                    return icon .. count
                end,
                -- color_icons = true,
                -- show_buffer_icons = true,
                -- show_buffer_close_icons = true,
                -- show_close_icon = true,
                -- show_tab_indicators = false,
                -- persist_buffer_sort = true,
                -- separator_style = "thin",
                -- enforce_regular_tabs = true,
                -- always_show_bufferline = true,
                -- sort_by = "id",
            },
        })
    end,
}
