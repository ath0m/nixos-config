local SOURCE_NAMES = {
  nvim_ciderlsp = "(Cider)",
  nvim_lsp = "(LSP)",
  luasnip = "(Snip)",
  buffer = "(Buffer)",
  path = "(Path)",
  buganizer = "(Bugged)",
}
local SOURCE_KIND_OVERRIDES = {
  buganizer = "󰃤 Bug",
  -- the AI magic star is basically required
  nvim_ciderlsp = " AI Text",
}

return {
  {
    -- :CmpStatus to verify loading
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        -- go/luasnip-google
        url = "sso://user/mccloskeybr/luasnip-google.nvim",
        dependencies = {
          {
            "L3MON4D3/LuaSnip",
          },
          { "saadparwaiz1/cmp_luasnip" },
        },
        config = function()
          require("luasnip-google").load_snippets()
        end,
      },
      {
        -- Add autocomplete when typing b/, BUG=, and FIXED=
        -- go/cmp-buganizer
        url = "sso://user/vicentecaycedo/cmp-buganizer",
        dependencies = { "nvim-lua/plenary.nvim" },
        cond = function()
          -- Requires buganizer CLI: go/bugged
          return vim.fn.executable("bugged") == 1
        end,
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")

      -- These sources were already defined by LazyVim,
      -- but we need a priority
      for _, source in ipairs(opts.sources) do
        if source.name == "nvim_lsp" then
          source.priority = 20
        elseif source.name == "luasnip" then
          source.priority = 10
        else
          source.priority = 1
        end
      end
      table.insert(opts.sources, { name = "nvim_ciderlsp", priority = 30 })
      table.insert(opts.sources, {
        name = "buganizer",
        priority = 30,
        option = { notifications_enabled = true },
      })

      local lazyvim_format = opts.formatting.format
      opts.formatting.format = function(entry, item)
        item = lazyvim_format(entry, item)
        item.kind = SOURCE_KIND_OVERRIDES[entry.source.name] or item.kind
        item.menu = SOURCE_NAMES[entry.source.name]
        return item
      end

      opts.sorting = vim.tbl_deep_extend("force", opts.sorting, {
        comparators = {
          -- Default comparators for nvim-cmp
          -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/default.lua#L67-L78
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          -- cmp.config.compare.scopes,
          cmp.config.compare.score,
          -- Rank items that start with "_", lower. i.e. private fields and methods.
          function(entry1, entry2)
            local _, entry1_under = entry1.completion_item.label:find("^_+")
            local _, entry2_under = entry2.completion_item.label:find("^_+")
            entry1_under = entry1_under or 0
            entry2_under = entry2_under or 0
            if entry1_under > entry2_under then
              return false
            elseif entry1_under < entry2_under then
              return true
            end
          end,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          -- cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      })

      return opts
    end,
  },
}
