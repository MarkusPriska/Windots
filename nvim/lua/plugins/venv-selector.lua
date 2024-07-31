return {
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap",
            "mfussenegger/nvim-dap-python", --optional
            { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
            -- Notifications
            "rcarriga/nvim-notify",
        },
        lazy = false,
        branch = "regexp", -- This is the regexp branch, use this for the new version
        config = function()
            require("venv-selector").setup({
                settings = {
                    options = {
                        on_venv_activate_callback = function()
                            require("core.utils").update_python_lualine()
                        end,
                    },
                },
            })
        end,
        keys = {
            { "<leader>cv", "<cmd>VenvSelect<cr>" },
        },
    },
}
