return {
    "echasnovski/mini.icons",
    specs = {
        { "nvim-tree/nvim-web-devicons", enabled = true, optional = true },
    },
    config = function()
        require("mini.icons").setup()
        require("mini.icons").mock_nvim_web_devicons()
    end,
}
