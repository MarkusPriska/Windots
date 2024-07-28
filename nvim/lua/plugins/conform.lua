return {
    "stevearc/conform.nvim",
    event = "BufReadPre",
    keys = {
        {
            -- Customize or remove this keymap to your liking
            "<leader>cf",
            function()
                require("conform").format({ async = true })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
    config = function()
        vim.g.disable_autoformat = true
        require("conform").setup({
            formatters_by_ft = {
                css = { "prettier" },
                html = { "prettier" },
                javascript = { "prettier" },
                json = { "prettier" },
                lua = { "stylua" },
                markdown = { "prettier" },
                ps1 = { "powershell", "trim_whitespace", "trim_newlines" },
                scss = { "prettier" },
                python = { "black" },
            },

            format_after_save = function()
                if vim.g.disable_autoformat then
                    return
                else
                    return { lsp_fallback = true }
                end
            end,

            formatters = {
                goimports_reviser = {
                    command = "goimports-reviser",
                    args = { "-output", "stdout", "$FILENAME" },
                },
                powershell = {
                    command = "pwsh",
                    args = {
                        "-NoLogo",
                        "-NoProfile",
                        "-NonInteractive",
                        "-Command",
                        "(Invoke-Formatter",
                        "(Get-Content -Raw -Path",
                        "$FILENAME",
                        ")).Trim()",
                    },
                },
            },
        })

        -- Override stylua's default indent type
        require("conform").formatters.stylua = {
            prepend_args = { "--indent-type", "Spaces" },
        }

        -- Override prettier's default indent type
        require("conform").formatters.prettier = {
            prepend_args = { "--tab-width", "4" },
        }

        -- Override blacks defualt args
        require("conform").formatters.black = {
            prepend_args = { "--fast", "--skip-string-normalization", "--line-length", "120" },
        }

        -- Toggle format on save
        vim.api.nvim_create_user_command("ConformToggle", function()
            vim.g.disable_autoformat = not vim.g.disable_autoformat
            print("Conform " .. (vim.g.disable_autoformat and "disabled" or "enabled"))
        end, {
            desc = "Toggle format on save",
        })
    end,
}
