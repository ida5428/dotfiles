require("config.lazy")
vim.cmd("set expandtab")
vim.cmd("set tabstop=3")
vim.cmd("set softtabstop=3")
vim.cmd("set shiftwidth=3")
vim.o.wrap = true
vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = false })