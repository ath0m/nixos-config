return {
  {
    "telescope.nvim",
    dependencies = {
      {
        "vintharas/telescope-codesearch.nvim",
        url = "sso://user/vintharas/telescope-codesearch.nvim",
        config = function()
          require("telescope").load_extension("codesearch")
        end,
        keys = {
          {
            "<leader>fq",
            "<cmd>Telescope codesearch find_files<cr>",
            desc = "Find Files (Codesearch)",
          },
          {
            "<leader>fQ",
            "<cmd>Telescope codesearch find_query<cr>",
            desc = "Find Files (Codesearch Query)",
          },
        },
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
    },
    opts = {
      defaults = {
        -- The vertical layout strategy is good to handle long paths like those in
        -- google3 repos because you have nearly the full screen to display a file path.
        -- The caveat is that the preview area is smaller.
        layout_strategy = "vertical",
        -- Common paths in google3 repos are collapsed following the example of Cider
        -- It is nice to keep this as a user config rather than part of
        -- telescope-codesearch because it can be reused by other telescope pickers.
        path_display = function(opts, path)
          -- Do common google3 substitutions
          path =
            path:gsub("^/google/src/cloud/[^/]+/[^/]+/google3/", "google3/", 1)
          path = path:gsub("^/google/src/cloud/[^/]+/[^/]+/", "depot/", 1)
          path = path:gsub("^google3/java/com/google/", "g3/j/c/g/", 1)
          path = path:gsub("^google3/javatests/com/google/", "g3/jt/c/g/", 1)
          path = path:gsub("^google3/third_party/", "g3/3rdp/", 1)
          path = path:gsub("^google3/", "g3/", 1)

          -- Do truncation. This allows us to combine our custom display formatter
          -- with the built-in truncation.
          -- `truncate` handler in transform_path memoizes computed truncation length in opts.__length.
          -- Here we are manually propagating this value between new_opts and opts.
          -- We can make this cleaner and more complicated using metatables :)
          local new_opts = {
            path_display = {
              truncate = true,
            },
            __length = opts.__length,
          }
          path = require("telescope.utils").transform_path(new_opts, path)
          opts.__length = new_opts.__length
          return path
        end,
      },
    },
  },
}
