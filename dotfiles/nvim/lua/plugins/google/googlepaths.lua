return {
  {
    -- Support google paths such as `//google3/*`
    url = "sso://user/fentanes/googlepaths.nvim",
    event = { "VeryLazy", "BufReadCmd //*" },
    opts = {},
  },
}
