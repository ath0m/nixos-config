return {
  {
    -- add support for google AI transform
    url = "sso://user/vvvv/ai.nvim",
    dependencies = {
      "rcarriga/nvim-notify",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>ct",
        "<cmd>TransformCode<cr>",
        mode = { "n", "v" },
        desc = "Transform Code (gAI)",
      },
    },
  },
}
