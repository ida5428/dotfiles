-- =========================
-- General Setup
-- =========================
vim.g.opened_by_yazi = os.getenv("NEOVIM_YAZI") and true or false

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
   pattern = "*",
   callback = function()
      vim.highlight.on_yank({ timeout = 100 })
   end,
   group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*_java.log",
  callback = function()
    vim.cmd("syntax on")
    vim.cmd("set syntax=java")
  end
})

-- =========================
-- Options
-- =========================
vim.opt.wrap = true
vim.opt.tabstop = 3
vim.opt.softtabstop = 3
vim.opt.expandtab = true
vim.opt.shiftwidth = 3
vim.opt.shiftround = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.swapfile = false

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 1
vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"

vim.opt.completeopt = { "menuone", "popup", "noinsert" }
vim.opt.winborder = "rounded"
vim.opt.cmdheight = 1
vim.opt.title = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- =========================
-- Keymaps
-- =========================
local map = vim.keymap.set
vim.g.mapleader = " "

-- Clipboard
map({ "n", "v" }, "<leader>y", '"+y')
map({ "n", "v" }, "<leader>d", '"+d')
map({ "n", "v" }, "<leader>p", '"+p')

-- Misc
map({ "n", "v" }, "<leader>c", "1z=")

-- Moving lines
map("n", "<C-j>", ":m .+1<CR>==")
map("n", "<C-k>", ":m .-2<CR>==")
map("v", "<C-j>", ":m '>+1<CR>gv=gv")
map("v", "<C-k>", ":m '<-2<CR>gv=gv")
map("n", "<C-S-J>", "yyp")
map("n", "<C-S-K>", "yyP")

-- File navigation
map("n", "<leader>e", ":Oil<CR>")
map("n", "<leader>f", ":Pick files<CR>")

-- =========================
-- Plugins (packer-style)
-- =========================
vim.pack.add({
   -- UI & Appearance
   { src = "https://github.com/vague2k/vague.nvim" },
   { src = "https://github.com/echasnovski/mini.nvim" },
   { src = "https://github.com/stevearc/oil.nvim" },
   { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
   { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
   { src = "https://github.com/nvim-lualine/lualine.nvim" },
   { src = "https://github.com/karb94/neoscroll.nvim" },
   { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
   { src = "https://github.com/folke/noice.nvim" },
   { src = "https://github.com/MunifTanjim/nui.nvim" },
   { src = "https://github.com/rcarriga/nvim-notify" },

   -- Mason + LSP + Completion
   { src = "https://github.com/neovim/nvim-lspconfig" },
   { src = "https://github.com/williamboman/mason.nvim" },
   { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
   { src = "https://github.com/Saghen/blink.cmp" },
})

-- =========================
-- mini.nvim Modules
-- =========================
require("mini.diff").setup()
require("mini.pick").setup()
require("mini.pairs").setup()
require("mini.icons").setup()
require("mini.surround").setup()
require('mini.indentscope').setup()

-- =========================
-- Extra Plugins Setup
-- =========================
require('render-markdown').setup({
    completions = { lsp = { enabled = true } },
})
require("oil").setup({
   delete_to_trash = true,
   view_options = {
      show_hidden = true,
   }
})
require("tiny-inline-diagnostic").setup()

-- Neoscroll keybindings
local neoscroll = require('neoscroll')
local scroll_keys = {
  ["<S-Up>"] = function() neoscroll.ctrl_u({ duration = 200 }) end,
  ["<S-Down>"] = function() neoscroll.ctrl_d({ duration = 200 }) end,
}
local modes = { 'n', 'v', 'x' }
for key, func in pairs(scroll_keys) do
  vim.keymap.set(modes, key, func)
end

-- =========================
-- Colorscheme
-- =========================
require("vague").setup({ transparent = true })
vim.cmd.colorscheme("vague")

-- =========================
-- Statusline (lualine)
-- =========================
require("lualine").setup({
   options = {
      theme = "auto",
      section_separators = { left = "", right = "" },
      component_separators = { left = "|", right = "|" },
      globalstatus = true,
   },
   sections = {
      lualine_a = { "mode" },
      lualine_b = { { "filename", path = 1 } },
      lualine_c = { "branch", "diff" },
      lualine_x = {
         function()
            local reg = vim.fn.reg_recording()
            if reg ~= '' then
               return "Recording @" .. reg
            end
            return ""
         end,
         function()
            return vim.g.opened_by_yazi and "[Yazi]" or ""
         end,
      },
      lualine_y = { "filetype" },
      lualine_z = { "progress", "location" },
   },
})

-- =========================
-- Noice + Notify
-- =========================
require("noice").setup({
   cmdline = {
      enabled = true,
      view = "cmdline_popup",
      format = {
         cmdline = { icon = "" },
         search_down = { icon = " " },
         search_up = { icon = " " },
      },
   },
   popupmenu = { enabled = true },
   messages = { enabled = true },
   lsp = { progress = { enabled = false } },
   presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
   },
})

require("notify").setup({
   background_colour = "#000000",
   render = "compact",
   stages = "static"
})

-- =========================
-- Mason + LSP
-- =========================
require("mason").setup()
require("mason-lspconfig").setup({
   ensure_installed = { "jdtls", "clangd" },
})

local lspconfig = require("lspconfig")
local capabilities = require("blink.cmp").get_lsp_capabilities()
local servers = { "jdtls", "clangd" }

for _, server in ipairs(servers) do
   lspconfig[server].setup({ capabilities = capabilities })
end

-- =========================
-- Completion (blink-cmp)
-- =========================
require("blink.cmp").setup({
   fuzzy = { implementation = "lua" },
   keymap = {
      preset = "default",
      ["<CR>"]  = { "accept", "fallback" },
      ["<C-x>"] = { "cancel" },
      ["<C-Space>"] = { "show" },
   },
   completion = {
      documentation = { auto_show = true },
      menu = { border = "rounded" },
   },
   sources = { default = { "lsp", "path", "buffer" } },
   signature = { enabled = true },
})

