-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local path = require("util.path")
local map = vim.keymap.set
local unmap = vim.keymap.del

-- Resize window using arrow keys
map("n", "<Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map(
  "n",
  "<Left>",
  "<cmd>vertical resize -2<cr>",
  { desc = "Decrease Window Width" }
)
map(
  "n",
  "<Right>",
  "<cmd>vertical resize +2<cr>",
  { desc = "Increase Window Width" }
)

-- Allow Shift-Space to open the command palette
map({ "n", "v" }, "<S-Space>", ":", { desc = "Command" })

-- If it is not a git repo, hide the git commands
if path.cwdVcsType() ~= path.VcsTypes.Git then
  unmap("n", "<leader>gg")
  unmap("n", "<leader>gG")
  unmap("n", "<leader>gb")
  unmap("n", "<leader>gB")
  unmap("n", "<leader>gf")
  unmap("n", "<leader>gL")
  unmap("n", "<leader>gc")
  unmap("n", "<leader>gs")
  unmap("n", "<leader>ge")
  unmap("n", "<leader>fg")

  if path.cwdVcsType() ~= path.VcsTypes.Fig then
    -- these were re-bound for Fig.
    unmap("n", "<leader>gl")
  end
end
