-- ╭──────────────────────────────────────────────────────────────╮
-- │                  BOOTSTRAP LAZY.NVIM                         │
-- ╰──────────────────────────────────────────────────────────────╯
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
   vim.fn.system({
      "git", "clone", "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
   })
end
vim.opt.rtp:prepend(lazypath)

-- ╭──────────────────────────────────────────────────────────────╮
-- │                          OPTIONS                             │
-- ╰──────────────────────────────────────────────────────────────╯
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 3
vim.opt.shiftwidth = 3
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 5
vim.opt.signcolumn = "no"
vim.opt.clipboard = "unnamedplus"

-- ╭──────────────────────────────────────────────────────────────╮
-- │                          KEYMAPS                             │
-- ╰──────────────────────────────────────────────────────────────╯
vim.g.mapleader = " "
local keymap = vim.keymap.set

keymap("n", "<leader>e", ":NvimTreeToggle<CR>")               -- file explorer
keymap("n", "<C-p>", ":Telescope find_files<CR>")             -- fuzzy file search
-- keymap("n", "<leader>pv", vim.cmd.Ex)                      -- netrw fallback
keymap("n", "<leader>w", ":w<CR>")                            -- save file
keymap("n", "<leader>q", ":q<CR>")                            -- quit file
keymap("i", "jk", "<Esc>", { noremap = true, silent = true }) -- exit insert mode
keymap("i", "as", "<Esc>", { noremap = true, silent = true }) -- alt exit

-- ╭──────────────────────────────────────────────────────────────╮
-- │                         PLUGINS                              │
-- ╰──────────────────────────────────────────────────────────────╯
require("lazy").setup({
   { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

   {
      "nvim-tree/nvim-tree.lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
         require("nvim-tree").setup()
      end,
   },

   { "nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = { "nvim-lua/plenary.nvim" } },
   { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
   { "tpope/vim-sleuth" },

   -- LSP and autocompletion
   { "neovim/nvim-lspconfig" },
   { "williamboman/mason.nvim", config = true },
   { "williamboman/mason-lspconfig.nvim" },

   -- Completion engine
   { "hrsh7th/nvim-cmp" },
   { "hrsh7th/cmp-nvim-lsp" },
   { "hrsh7th/cmp-buffer" },
   { "hrsh7th/cmp-path" },
   { "hrsh7th/cmp-cmdline" },
   { "hrsh7th/cmp-nvim-lua" },

   -- Snippets
   { "L3MON4D3/LuaSnip" },
   { "saadparwaiz1/cmp_luasnip" },

   {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
         require("lualine").setup({
            options = {
               theme = "catppuccin",
               section_separators = "",
               component_separators = "",
            },
         })
      end,
   },

   {
      "folke/noice.nvim",
      dependencies = {
         "MunifTanjim/nui.nvim",
         -- "rcarriga/nvim-notify",
      },
      config = function()
         require("noice").setup({
            cmdline = {
               view = "cmdline_popup",
               opts = {
                  position = { row = "50%", col = "50%" },
                  size = { width = 60, height = "auto" },
               },
            },
         })
      end,
   },

   {
      "goolord/alpha-nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
         local alpha = require("alpha")
         local dashboard = require("alpha.themes.dashboard")

         dashboard.section.header.val = {
            "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
            "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
            "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
            "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
            "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
            "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
         }

         dashboard.section.buttons.val = {
            dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
            dashboard.button("n", "  New file", ":enew<CR>"),
            dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
            dashboard.button("g", "  Find text", ":Telescope live_grep<CR>"),
            dashboard.button("c", "  Config", ":e ~/.config/nvim/init.lua<CR>"),
            dashboard.button("s", "  Restore Session", ":lua require('persistence').load()<CR>"),
            dashboard.button("l", "鈴 Lazy", ":Lazy<CR>"),
            dashboard.button("q", " Quit", ":qa<CR>"),
         }

         dashboard.section.footer.val = "⚡ Neovim loaded " .. require("lazy").stats().count .. " plugins"
         alpha.setup(dashboard.config)
      end,
   },
})

vim.cmd.colorscheme("catppuccin-mocha")

-- ╭──────────────────────────────────────────────────────────────╮
-- │                          LSP Setup                           │
-- ╰──────────────────────────────────────────────────────────────╯
require("mason").setup()
require("mason-lspconfig").setup({
   ensure_installed = {
      "clangd",     -- C++
      "jdtls",      -- Java
   },
})

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local servers = { "clangd", "jdtls", "lua_ls" }

for _, server in ipairs(servers) do
   lspconfig[server].setup({ capabilities = capabilities })
end

-- ╭──────────────────────────────────────────────────────────────╮
-- │                   Autocompletion Setup (CMP)                 │
-- ╰──────────────────────────────────────────────────────────────╯
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
   snippet = {
      expand = function(args)
         luasnip.lsp_expand(args.body)
      end,
   },
   mapping = cmp.mapping.preset.insert({
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
         if cmp.visible() then
            cmp.select_next_item()
         elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
         else
            fallback()
         end
      end, { "i", "s" }),
   }),
   sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
   }, {
      { name = "buffer" },
   }),
})
