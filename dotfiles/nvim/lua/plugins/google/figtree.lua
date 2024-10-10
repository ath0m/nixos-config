local path = require("util.path")

return {
  {
    -- add integration with fig including highlighting changed lines
    url = "sso://user/jackcogdill/nvim-figtree",
    lazy = false,
    cond = function()
      return path.cwdVcsType() == path.VcsTypes.Fig
    end,
    keys = {
      { "<leader>gl", "<cmd>Figtree<cr>", desc = "Figtree" },
    },
  },
}
