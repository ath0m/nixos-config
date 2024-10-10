-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = false

-- automatically sync with system clipboard
vim.opt.clipboard = "unnamedplus"

-- vim.opt.tabstop = 2 -- A TAB character looks like 2 spaces
-- vim.opt.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
-- vim.opt.softtabstop = 2 -- Number of spaces inserted instead of a TAB character
-- vim.opt.shiftwidth = 2 -- Number of spaces inserted when indenting

-- enable spell-checking by default
vim.opt.spell = true

-- LazyVim root dir detection
-- Just use cwd because google3 is big and it is hard to pick a reasonable default
vim.g.root_spec = { "cwd" }
