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
        on_open = function(_)
            local name = vim.fn.bufname("neo-tree")
            local winnr = vim.fn.bufwinnr(name)

            if winnr ~= -1 then
                vim.defer_fn(function()
                    local cmd = string.format("Neotree toggle")
                    vim.cmd(cmd)
                    vim.cmd(cmd)
                    vim.cmd("wincmd p")
                end, 100)
            end
        end,
    },
}
