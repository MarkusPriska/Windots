return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
        -- Helper function to get highlight group
        local function get_hlgroup(name, fallback)
            if vim.fn.hlexists(name) == 1 then
                local group = vim.api.nvim_get_hl(0, { name = name })
                return {
                    fg = group.fg and string.format("#%06x", group.fg) or "NONE",
                    bg = group.bg and string.format("#%06x", group.bg) or "NONE",
                }
            end
            return fallback or {}
        end

        -- Helper function to get buffer count
        local function get_buffer_count()
            local count = 0
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.fn.bufname(buf) ~= "" then
                    count = count + 1
                end
            end
            return count
        end

        local copilot_colors = {
            [""] = get_hlgroup("Comment"),
            ["Normal"] = get_hlgroup("Comment"),
            ["Warning"] = get_hlgroup("DiagnosticError"),
            ["InProgress"] = get_hlgroup("DiagnosticWarn"),
        }

        return {
            options = {
                component_separators = { left = " ", right = " " },
                section_separators = { left = " ", right = " " },
                theme = "auto",
                globalstatus = true,
                disabled_filetypes = { statusline = { "dashboard", "alpha" } },
            },
            sections = {
                lualine_a = { { "mode", icon = "" } },
                lualine_b = { "branch" },
                lualine_c = {
                    {
                        "diagnostics",
                        symbols = {
                            error = "󰅚 ",
                            warn = "󰀪 ",
                            info = "󰋽 ",
                            hint = "󰌶 ",
                        },
                    },
                    { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                    { "filename", 
                        path = 1, -- 0 = filename only, 1 = relative path, 2 = absolute path, 3 = absolute with tilde
                        padding = { left = 1, right = 0 },
                        symbols = { 
                            modified = '', 
                            readonly = '', 
                            unnamed = '' 
                        }
                    },
                    {
                        function()
                            local tab_count = vim.fn.tabpagenr("$")
                            if tab_count > 1 then
                                return vim.fn.tabpagenr() .. " of " .. tab_count
                            end
                        end,
                        cond = function()
                            return vim.fn.tabpagenr("$") > 1
                        end,
                        icon = "󰓩",
                        color = get_hlgroup("Special", nil),
                    },
                },
                lualine_x = {
                    {
                        function()
                            local venv = vim.env.VIRTUAL_ENV
                            if venv then
                                local venv_name = vim.fn.fnamemodify(venv, ":t")
                                return "󰌠 " .. venv_name
                            end
                            -- Check if venv-selector has a cached venv
                            local ok, venv_selector = pcall(require, "venv-selector")
                            if ok then
                                local venv_path = venv_selector.get_active_venv()
                                if venv_path then
                                    local venv_name = vim.fn.fnamemodify(venv_path, ":h:t")
                                    return "󰌠 " .. venv_name
                                end
                            end
                            return ""
                        end,
                        cond = function()
                            return vim.bo.filetype == "python"
                        end,
                        color = get_hlgroup("Function"),
                    },
                    {
                        require("lazy.status").updates,
                        cond = require("lazy.status").has_updates,
                        color = get_hlgroup("String"),
                    },
                    {
                        function()
                            local icon = "󰚩 "
                            local status = require("copilot.api").status.data
                            return icon .. (status.message or "")
                        end,
                        cond = function()
                            local ok, clients = pcall(vim.lsp.get_clients, { name = "copilot", bufnr = 0 })
                            return ok and #clients > 0
                        end,
                        color = function()
                            if not package.loaded["copilot"] then
                                return
                            end
                            local status = require("copilot.api").status.data
                            return copilot_colors[status.status] or copilot_colors[""]
                        end,
                    },
                },
                lualine_y = {
                    {
                        "progress",
                    },
                    {
                        "location",
                        color = get_hlgroup("Boolean"),
                    },
                },
                lualine_z = {
                    {
                        "datetime",
                        style = "󰥔 %X",
                    },
                },
            },

            extensions = { "lazy", "toggleterm", "mason", "neo-tree", "trouble" },
        }
    end,
}
