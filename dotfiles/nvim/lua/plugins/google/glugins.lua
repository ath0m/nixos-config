local glug = require("util.glug").glug
local veryLazy = require("util.very-lazy").veryLazy
local path = require("util.path")

return {
  glug("maktaba", {
    lazy = true,
    dependencies = {},
    config = function()
      vim.cmd("source /usr/share/vim/google/glug/bootstrap.vim")
    end,
  }),

  -- Enable logmsgs ASAP to avoid maktaba's log message queue filling up
  glug("logmsgs", {
    event = "VeryLazy",
  }),

  -- basic googler-specific functionality such as logging plugin usage.
  glug("googler", {
    event = "VeryLazy",
  }),

  -- Add support for google filetypes
  glug(
    "google-filetypes",
    { event = { "BufReadPre", "BufNewFile" }, dependencies = {} }
  ),

  -- Other filetype detection
  veryLazy(glug("ft-cel", { event = "BufRead,BufNewFile *.cel,*jvp" })),
  veryLazy(glug("ft-clif", { event = "BufRead,BufNewFile *.clif" })),
  veryLazy(glug("ft-gin", { event = "BufRead,BufNewFile *.gin" })),
  veryLazy(glug("ft-gss", { event = "BufRead,BufNewFile *.gss" })),
  veryLazy(
    glug(
      "ft-proto",
      { event = "BufRead,BufNewFile *.proto,*.protodevel,*.rosy,*.textproto" }
    )
  ),
  veryLazy(glug("ft-soy", { event = "BufRead,BufNewFile *.soy" })),

  -- Set up syntax, indent, and core settings for various filetypes
  veryLazy(glug("ft-cpp", { event = "BufRead,BufNewFile *.[ch],*.cc,*.cpp" })),
  veryLazy(glug("ft-go", { event = "BufRead,BufNewFile *.go" })),
  veryLazy(glug("ft-java", { event = "BufRead,BufNewFile *.java" })),
  veryLazy(glug("ft-javascript", { event = "BufRead,BufNewFile *.js,*.jsx" })),
  veryLazy(glug("ft-kotlin", { event = "BufRead,BufNewFile *.kt,*.kts" })),
  veryLazy(glug("ft-python", { event = "BufRead,BufNewFile *.py" })),

  -- Configures nvim to respect Google's coding style
  veryLazy(glug("googlestyle", { event = { "BufRead", "BufNewFile" } })),

  -- Autogens boilerplate when creating new files
  glug("autogen", {
    event = "BufNewFile",
  }),

  -- Format google code
  glug("codefmt-google", {
    dependencies = {
      glug("codefmt", {
        clang_format_executable = "/usr/bin/clang-format",
        clang_format_style = "function('codefmtgoogle#GetClangFormatStyle')",
        gofmt_executable = "/usr/lib/google-golang/bin/gofmt",
        dartfmt_executable = { "/usr/lib/google-dartlang/bin/dart", "format" },
        ktfmt_executable = "/google/bin/releases/kotlin-google-eng/ktfmt/ktfmt",
      }),
    },
    cmd = { "FormatLines", "FormatCode", "AutoFormatBuffer" },
    -- Setting up autocmds in init allows deferring loading the plugin until
    -- the `BufWritePre` event. One caveat is we must call `codefmt#FormatBuffer()`
    -- manually the first time since the plugin relies on the `BufWritePre` command to call it,
    -- but by the time it's first loaded it has already happened.
    -- TODO: check if that is fixed when the following issue is fixed
    -- https://github.com/folke/lazy.nvim/issues/858
    -- if so, remove the call to `FormatBuffer`
    init = function(plugin)
      local group = vim.api.nvim_create_augroup("autoformat_settings", {})
      local function autocmd(filetype, formatter)
        vim.api.nvim_create_autocmd("FileType", {
          pattern = filetype,
          group = group,
          callback = function(event)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = event.buf,
              group = group,
              once = true,
              callback = function()
                if
                  vim.api.nvim_eval('exists("b:_use_ciderlsp_formatter")') == 0
                then
                  vim.cmd(
                    "call codefmt#FormatBuffer() | AutoFormatBuffer "
                      .. formatter
                  )
                end
              end,
            })
          end,
        })
      end

      -- Build opts from possible parent specs since lazy.nvim doesn't provide it in `init`
      local plugin_opts =
        require("lazy.core.plugin").values(plugin, "opts", false)
      for filetype, formatter in pairs(plugin_opts.auto_format or {}) do
        autocmd(filetype, formatter)
      end
    end,
  }),

  -- Show related files, ie BUILD, tests
  glug("relatedfiles", {
    cmd = "RelatedFilesWindow",
    keys = {
      {
        "<leader>fx",
        "<cmd>RelatedFilesWindow<cr>",
        desc = "Related Files",
      },
    },
  }),
}
