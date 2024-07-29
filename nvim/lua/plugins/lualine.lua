return {
   "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "echasnovski/mini.icons", "rcarriga/nvim-notify" },
    opts = function()
        local utils = require("core.utils")
        local api = require("supermaven-nvim.api")

        local supermaven_colors = {
            [""] = utils.get_hlgroup("Comment"),
            ["Normal"] = utils.get_hlgroup("Comment"),
            ["Warning"] = utils.get_hlgroup("DiagnosticError"),
            ["InProgress"] = utils.get_hlgroup("DiagnosticWarn"),
        }

        local filetype_map = {
            lazy = { name = "lazy.nvim", icon = "💤" },
            minifiles = { name = "minifiles", icon = "🗂️ " },
            toggleterm = { name = "terminal", icon = "🐚" },
            mason = { name = "mason", icon = "🔨" },
            TelescopePrompt = { name = "telescope", icon = "🔍" },
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
                lualine_a = {
                    {
                        "mode",
                        icon = "",
                        fmt = function(mode)
                            return mode:lower()
                        end,
                    },
                },
                lualine_b = { { "branch", icon = "" } },
                lualine_c = {
                    {
                        "diagnostics",
                        symbols = {
                            error = " ",
                            warn = " ",
                            info = " ",
                            hint = "󰝶 ",
                        },
                    },
                    {
                        function()
                            local devicons = require("nvim-web-devicons")
                            local ft = vim.bo.filetype
                            local icon
                            if filetype_map[ft] then
                                return " " .. filetype_map[ft].icon
                            end
                            if icon == nil then
                                icon = devicons.get_icon(vim.fn.expand("%:t"))
                            end
                            if icon == nil then
                                icon = devicons.get_icon_by_filetype(ft)
                            end
                            if icon == nil then
                                icon = " 󰈤"
                            end

                            return icon .. " "
                        end,
                        color = function()
                            local _, hl = require("nvim-web-devicons").get_icon(vim.fn.expand("%:t"))
                            if hl then
                                return hl
                            end
                            return utils.get_hlgroup("Normal")
                        end,
                        separator = "",
                        padding = { left = 0, right = 0 },
                    },
                    {
                        "filename",
                        padding = { left = 0, right = 0 },
                        fmt = function(name)
                            if filetype_map[vim.bo.filetype] then
                                return filetype_map[vim.bo.filetype].name
                            else
                                return name
                            end
                        end,
                    },
                    {
                        function()
                            local buffer_count = require("core.utils").get_buffer_count()

                            return "+" .. buffer_count - 1 .. " "
                        end,
                        cond = function()
                            return require("core.utils").get_buffer_count() > 1
                        end,
                        color = utils.get_hlgroup("Operator", nil),
                        padding = { left = 0, right = 1 },
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
                        color = utils.get_hlgroup("Special", nil),
                    },
                    {
                        function()
                            return require("nvim-navic").get_location()
                        end,
                        cond = function()
                            return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
                        end,
                        color = utils.get_hlgroup("Comment", nil),
                    },
                },
                lualine_x = {
                    {
                        require("lazy.status").updates,
                        cond = require("lazy.status").has_updates,
                        color = utils.get_hlgroup("String"),
                    },
                    {
                        function()
                            local icon = " "
                            return icon
                        end,
                        cond = function()
                            local is_loaded = api.is_running()
                            return is_loaded
                        end,
                        color = function()
                            if not package.loaded["supermaven-nvim"] then
                                require("notify")("Supermaven is not loaded", "info", { title = "Supermaven" })
                                return
                            end
                            local status = api.is_running() and "Normal" or "Warning"
                            return supermaven_colors[status] or supermaven_colors[""]
                        end,
                    },
                    { "diff" },
                },
                lualine_y = {
                    {
                        "progress",
                    },
                    {
                        "location",
                        color = utils.get_hlgroup("Boolean"),
                    },
                },
                lualine_z = {
                    {
                        "datetime",
                        style = "  %X",
                    },
                },
            },
        }
    end,
}
