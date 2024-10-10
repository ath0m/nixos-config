local path = require("util.path")

return {
  -- Highlight changed lines in gutter for fig
  {
    "mhinz/vim-signify",
    opts = {
      updatetime = 500,
      use_prev_commit_rev = true,
    },
    cond = function()
      return path.cwdVcsType() == path.VcsTypes.Fig
    end,
    config = function(_, opts)
      -- A small `updatetime` is preferred to update signs as files are updated
      -- The default `updatetime` is 4000
      vim.opt.updatetime = opts.updatetime
      vim.api.nvim_set_hl(0, "SignifySignAdd", { ctermfg = "green", fg = "#79b7a5" })
      vim.api.nvim_set_hl(0, "SignifySignChange", { ctermfg = "yellow", fg = "#ffffcc" })
      vim.api.nvim_set_hl(0, "SignifySignChangeDelete", { ctermfg = "red", fg = "#ff7b72" })
      vim.api.nvim_set_hl(0, "SignifySignDelete", { ctermfg = "red", fg = "#ff7b72" })
      vim.api.nvim_set_hl(0, "SignifySignDeleteDeleteFirstLine", { ctermfg = "red", fg = "#ff7b72" })
      if opts.use_prev_commit_rev then
        vim.g.signify_vcs_cmds = { hg = "hg --config alias.diff=diff diff --color=never --nodates -U0 --rev .^ -- %f" }
        vim.g.signify_vcs_cmds_diffmode = { hg = "hg cat --rev .^ %f" }
      end
    end,
  },
}
