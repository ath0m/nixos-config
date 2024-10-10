-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local inlay_hint_buffers = {}

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup(
    "lazygoog_inlay_hints_attach",
    { clear = true }
  ),
  callback = function(event)
    inlay_hint_buffers[event.buf] = true
  end,
})

vim.api.nvim_create_autocmd("LspTokenUpdate", {
  group = vim.api.nvim_create_augroup("lazygoog_inlay_hints", { clear = true }),
  callback = function(event)
    if inlay_hint_buffers[event.buf] then
      inlay_hint_buffers[event.buf] = false
    else
      return
    end
    if not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }) then
      -- vim.notify(
      --   "Lsp inlay hint not enabled for " .. tostring(event.buf),
      --   "info"
      -- )
      return
    end

    -- vim.notify("Enable inlay hints after lsp response " .. tostring(event.buf), "info")
    vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
  end,
})
