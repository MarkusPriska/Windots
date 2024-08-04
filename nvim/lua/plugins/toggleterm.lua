local function find_neo_tree_win()
    local windows = vim.api.nvim_list_wins()
    for _, win in ipairs(windows) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.fn.bufname(buf)
        if buf_name:match("neo%-tree") then
            return win
        end
    end
    return nil
end

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
            local neo_tree_win = find_neo_tree_win()
            if neo_tree_win then
                vim.defer_fn(function()
                    vim.cmd("Neotree toggle")
                    vim.cmd("Neotree toggle")
                    vim.cmd("wincmd p")
                end, 100)
            else
                vim.print("Neo-tree window not found")
            end
        end,
    },
}
