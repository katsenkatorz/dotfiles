-- Options loaded before lazy.nvim startup.
-- LazyVim defaults: https://www.lazyvim.org/configuration/general
local opt = vim.opt

opt.scrolloff = 8
opt.relativenumber = true
opt.wrap = false

-- 2-space indents everywhere (Biome/ultracite convention in every repo here)
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true

-- macOS system clipboard is the default register
opt.clipboard = "unnamedplus"

-- Prettier only runs in projects that carry a prettier config;
-- everywhere else Biome (the house formatter) owns formatting
vim.g.lazyvim_prettier_needs_config = true
