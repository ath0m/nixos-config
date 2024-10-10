local M = {
  results = {},
}

M.VcsTypes = {
  None = 0,
  Git = 1,
  Fig = 2,
}

M.vcsType = function(dir)
  if vim.startswith(dir, "/google") then
    return M.VcsTypes.Fig
  end
  local handle = io.popen(
    'git -C "' .. dir .. '" rev-parse --is-inside-work-tree 2> /dev/null'
  )
  print(handle)
  local is_git = false
  if handle ~= nil then
    local output = handle:read("*a")
    is_git = output:match("true") ~= nil
  end

  if is_git then
    return M.VcsTypes.Git
  else
    return M.VcsTypes.None
  end
end

M.cwdVcsType = function()
  local cwd = vim.fn.getcwd()
  return M.vcsType(cwd)
end

M.bufferPath = function()
  return vim.fn.expand("%:p")
end

return M
