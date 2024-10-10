return {
  {
    "epwalsh/obsidian.nvim",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Required pngpaste on MacOS. `brew install pngpaste`
    },
    ft = { "markdown" },
    keys = {
      {
        "<leader>nb",
        "<cmd>ObsidianBacklinks<cr>",
        desc = "obsidian backlinks",
      },
      { "<leader>nf", "<cmd>ObsidianQuickSwitch<cr>", desc = "obsidian find" },
      { "<leader>ni", "<cmd>ObsidianPasteImg<cr>", desc = "obsidian img" },
      {
        "<leader>njm",
        "<cmd>ObsidianTomorrow<cr>",
        desc = "obsidian tomorrow",
      },
      { "<leader>njt", "<cmd>ObsidianToday<cr>", desc = "obsidian today" },
      {
        "<leader>njy",
        "<cmd>ObsidianYesterday<cr>",
        desc = "obsidian yesterday",
      },
      { "<leader>njd", "<cmd>ObsidianDailies<cr>", desc = "obsidian dailies" },
      { "<leader>nll", "<cmd>ObsidianLink<cr>", desc = "obsidian link" },
      { "<leader>nln", "<cmd>ObsidianLinkNew<cr>", desc = "obsidian link new" },
      { "<leader>nn", "<cmd>ObsidianNew<cr>", desc = "obsidian new" },
      { "<leader>no", "<cmd>ObsidianOpen<cr>", desc = "obsidian open" },
      { "<leader>nr", "<cmd>ObsidianRename<cr>", desc = "obsidian rename" },
      { "<leader>ns", "<cmd>ObsidianSearch<cr>", desc = "obsidian search" },
      { "<leader>nt", "<cmd>ObsidianTags<cr>", desc = "obsidian tags" },
      {
        "<leader>nwm",
        "<cmd>ObsidianWorkspace main<cr>",
        desc = "select workspace main",
      },
      {
        "<localleader>mx",
        function()
          require("obsidian.util").toggle_checkbox()
        end,
        desc = "mark complete",
      },
    },
    opts = {
      daily_notes = {
        alias_format = "%Y-%m-%d",
        folder = "journal",
      },
      follow_url_func = function(url)
        vim.fn.jobstart({ "open", url })
      end,
      note_id_func = function(title)
        -- Given "Note Name" will make ID `<timestamp>-note-name`.
        -- Filename is the same with `.md` suffix.
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,
      open_app_foreground = true,
      preferred_link_style = "markdown",
      ui = { enable = false },
      workspaces = {
        {
          name = "main",
          path = "~/rain",
        },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    opts = {
      file_types = { "markdown", "Avante" },
      heading = {
        sign = true,
      },
    },
  },
  {
    "tadmccorkle/markdown.nvim",
    ft = "markdown",
    opts = {
      mappings = {
        go_curr_heading = "[c",
        go_parent_heading = "[p",
      },
      on_attach = function(bufnr)
        vim.keymap.set(
          { "n", "i" },
          "<m-o>",
          "<cmd>MDListItemBelow<cr>",
          { buffer = bufnr, desc = "item below" }
        )
        vim.keymap.set(
          { "n", "i" },
          "<m-O>",
          "<cmd>MDListItemAbove<cr>",
          { buffer = bufnr, desc = "item above" }
        )
      end,
    },
  },
}
