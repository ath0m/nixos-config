return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { -- adds additional google-specific cpp support
        "smartpde/tree-sitter-cpp-google",
        config = function()
          require("tree-sitter-cpp-google").setup()
        end,
      },
    },
    opts = {
      auto_install = true,
    },
  },
}
