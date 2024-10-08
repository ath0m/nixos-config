-- from cs/google3/experimental/users/fentanes/nvgoog/lua/nvgoog/google/coding.lua
return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        borg = { "gclfmt" },
        gcl = { "gclfmt" },
        patchpanel = { "gclfmt" },
        bzl = { "buildifier" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        dart = { "tidy_dart", "dartfmt" },
        go = { "gofmt" },
        java = { "google-java-format" },
        jslayout = { "jslfmt" },
        markdown = { "mdformat" },
        ncl = { "nclfmt" },
        python = { "pyformat" },
        piccolo = { "pyformat" },
        soy = { "soyfmt" },
        textpb = { "txtpbfmt" },
        proto = { "protofmt" },
        sql = { "format_sql" },
        googlesql = { "format_sql" },
        terraform = { "terraform" },
      },
      formatters = {
        gclfmt = {
          command = "/google/data/ro/projects/borg/gclfmt",
          args = {},
          stdin = true,
          range_args = function(ctx)
            return { "--incremental", "--lines", ctx.range.start[1], ":", ctx.range["end"][1], "-" }
          end,
        },
        mdformat = {
          command = "/google/bin/releases/corpeng-engdoc/tools/mdformat",
          args = {},
          range_args = function(ctx)
            return { "-", "--lines", ctx.range.start[1], ":", ctx.range["end"][1] }
          end,
          stdin = true,
        },
        nclfmt = {
          command = "/google/src/head/depot/google3/configlang/ncl/release/nclfmt.k8",
          args = { "-" },
          stdin = true,
        },
        jslfmt = {
          command = "/google/data/ro/projects/gws/tools/direct/jslayout_builder",
          args = { "--mode=format", "-" },
          stdin = true,
        },
        txtpbfmt = {
          command = "/google/bin/releases/text-proto-format/public/fmt",
          args = {},
          stdin = true,
        },
        protofmt = {
          command = "/google/bin/releases/client-proto-wg/protofmt/protofmt",
          args = {},
          stdin = true,
        },
        format_sql = {
          command = "/google/data/ro/teams/googlesql-formatter/fmt",
          args = {},
          stdin = true,
        },
        pyformat = {
          command = "pyformat",
          args = { "--assume_filename", "$FILENAME" },
          stdin = true,
          range_args = function(ctx)
            return { "--lines", ctx.range.start[1] .. "-" .. ctx.range["end"][1] }
          end,
        },
        soyfmt = {
          command = "/google/data/rw/teams/frameworks-web-tools/soy/format/live/bin_deploy.jar",
          args = { "--assume_filename", "$FILENAME" },
          stdin = true,
          range_args = function(ctx)
            return { "--lines", ctx.range.start[1] .. "-" .. ctx.range["end"][1] }
          end,
        },
        tidy_dart = {
          command = "/google/data/ro/teams/tidy_dart/tidy_dart",
          args = { "--stdinFilename", "$FILENAME" },
          stdin = true,
        },
        dartfmt = {
          command = "/usr/lib/google-dartlang/bin/dart",
          args = { "format" },
          stdin = true,
        },
        terraform = {
          command = "/google/data/ro/teams/terraform/bin/terraform",
          args = {},
          stdin = true,
        },
        prettier = {
          command = "/google/data/ro/teams/prettier/prettier",
          args = { "--stdin-filepath", "$FILENAME" },
          stdin = true,
        },
      },
    },
  },
}
