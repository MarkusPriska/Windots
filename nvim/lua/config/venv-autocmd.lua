-- Auto-activate .venv if it exists in the project root
vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
  pattern = "*",
  callback = function()
    local venv = vim.fn.getcwd() .. "/.venv"
    if vim.fn.isdirectory(venv) == 1 then
      vim.env.VIRTUAL_ENV = venv
      vim.env.PATH = venv .. "/bin:" .. vim.env.PATH
      vim.g.python3_host_prog = venv .. "/bin/python"
    end
  end,
  desc = "Auto-activate .venv if present"
})