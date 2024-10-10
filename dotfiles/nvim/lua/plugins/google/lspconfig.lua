-- from cs/google3/experimental/users/fentanes/nvgoog/lua/nvgoog/google/lsp.lua
-- and from https://www.lazyvim.org/plugins/lsp#nvim-lspconfig
-- Configure CiderLSP
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    {
      -- go/cmp-nvim-ciderlsp
      url = "sso://user/sakal/cmp-nvim-ciderlsp",
    },
  },
  opts = function(_, opts)
    local ciderlsp_config = {
      cmd = {
        "/google/bin/releases/cider/ciderlsp/ciderlsp",
        "--tooltag=nvim-lsp",
        "--noforward_sync_responses",
      },
      -- From the table at http://go/ciderlsp
      filetypes = {
        "c",
        "cpp",
        "objc",
        "objcpp",
        "java",
        "kotlin",
        "go",
        "python",
        "typescript",
        "typescriptreact",
        "proto",
        "textproto",
        "dart",
        "bzl",
        "cs",
        "googlesql",
        "eml",
        "mlir",
        "dataz",
        "soy",
        "graphql",

        -- CiderLSP does have some support for more filetypes that are
        -- not listed in the table above.
        "javascript",
        "javascriptreact",
        "css",
        "scss",
        "html",
        "json",
        "jslayout",
        "gcl",
        "borg",
        "markdown",
        "piccolo",
        "ncl",
        "conf",
      },
      root_dir = require("lspconfig").util.root_pattern(".citc"),
      -- https://github.com/neovim/neovim/issues/19237
      on_init = function(client)
        client.offset_encoding = "utf-8"
      end,
      settings = {},
    }
    require("lspconfig.configs").ciderlsp = {
      default_config = ciderlsp_config,
    }

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities =
      require("cmp_nvim_ciderlsp").update_capabilities(capabilities)

    return vim.tbl_deep_extend("force", opts, {
      inlay_hints = {
        enabled = true,
        exclude = {
          "markdown",
          "bzl",
          "json",
          "proto",
          "textproto",
          "objc",
          "dart",
          "objcpp",
          "eml",
          "mlir",
          "dataz",
          "soy",
          "graphql",
        },
      },
      codelens = { enabled = true },
      servers = {
        ciderlsp = {
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            -- TODO(b/324369022): Diagnostics don't show up when first opening a file.
            -- The below is done to remedy this, a `textDocument/didChange` call is made
            -- that gets updated diagnostics. Remove when this bug is fixed.
            client.request("textDocument/didChange", {
              textDocument = { uri = vim.uri_from_bufnr(bufnr), version = 2 },
            }, function() end)
          end,
        },
      },
    })
  end,
  -- config = function(plugin, opts)
  --   --
  --   -- LazyVim
  --   --
  --   local original_config = require("lazyvim.plugins.lsp.init")[1]
  --   assert(original_config[1] == "neovim/nvim-lspconfig", "Wrong plugin config found")
  --   original_config.config(plugin, opts)

  --   --
  --   -- nvgoog
  --   --
  --   local lspconfig = require("lspconfig")
  --   if not opts.servers or not opts.servers.ciderlsp then
  --     vim.notify("Unable to setup CiderLSP", vim.log.levels.WARN)
  --   else
  --     opts.servers.ciderlsp.on_attach = function(client, bufnr)
  --       -- TODO(b/324369022): Diagnostics don't show up when first opening a file.
  --       -- The below is done to remedy this, a `textDocument/didChange` call is made
  --       -- that gets updated diagnostics. Remove when this bug is fixed.
  --       client.request("textDocument/didChange", {
  --         textDocument = { uri = vim.uri_from_bufnr(bufnr), version = 2 },
  --       }, function() end)
  --     end
  --   end
  --   for server_name, server_opts in pairs(opts.servers or {}) do
  --     lspconfig[server_name].setup(server_opts)
  --   end
  -- end,
}
