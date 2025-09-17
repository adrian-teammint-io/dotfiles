return {
  {
    "folke/noice.nvim",
    lazy = false,
    -- event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = { event = "notify", find = "No information available" },
        opts = { skip = true },
      })
      opts.presets.lsp_doc_border = true
      -- opts.presets.inc_rename = true
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    opts = {
      defaults = {
        sorting_strategy = "ascending",
        layout_strategy = "flex",
        layout_config = {
          horizontal = { preview_cutoff = 80, preview_width = 0.55 },
          vertical = { mirror = true, preview_cutoff = 25 },
          prompt_position = "top",
          width = 0.87,
          height = 0.80,
        },
      },
    },
    config = function()
      require("plugins.configs.telescope")
    end,
    dependencies = {
      { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
      { "nvim-telescope/telescope-frecency.nvim" },
      { "danielvolchek/tailiscope.nvim" },
      { "debugloop/telescope-undo.nvim" },
      { "benfowler/telescope-luasnip.nvim" },
      { "mollerhoj/telescope-recent-files.nvim" },
    },
    keys = {
      {
        "<leader>f",
        function()
          require("telescope.builtin").find_files()
          -- vim.cmd([[Telescope recent-files recent_files theme=ivy cwd_only=true]])
          -- vim.cmd([[Telescope recent-files recent_files cwd_only=true]])
          -- require("telescope").extensions.smart_open.smart_open({
          --   cwd_only = true,
          --   filename_first = false,
          -- })
        end,
        desc = "Find Files",
      },
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Telescope: Find Config Files",
      },
      {
        "<leader>/",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find()
        end,
        desc = "Telescope: Buffer Fuzzy Finder",
      },
      {
        "<leader>d",
        function()
          local builtin = require("telescope.builtin")
          builtin.diagnostics()
        end,
        desc = "Telescope: Diagnostics",
      },
      {
        "<leader>o",
        function()
          -- vim.cmd([[Telescope frecency theme=ivy]])
          require("telescope.builtin").oldfiles()
        end,
        desc = "Find Old Files",
      },
      -- {
      --   "<leader>ls",
      --   function()
      --     vim.cmd([[Telescope luasnip theme=dropdown]])
      --   end,
      --   desc = "Find Old Files",
      -- },
      {
        "<leader>gz",
        function()
          vim.cmd([[Telescope live_grep]])
        end,
        desc = "Telescope: Live Grep",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
    defaults = {},
    pickers = {
      current_buffer_fuzzy_finder = {
        theme = "dropdown",
      },
    },
    extensions = {},
  },

  -- UI for Telescope
  { "nvim-telescope/telescope-ui-select.nvim", event = "VeryLazy" },
  {
    "danielfalk/smart-open.nvim",
    branch = "0.2.x",
    config = function()
      require("telescope").load_extension("smart_open")
    end,
    dependencies = {
      "kkharji/sqlite.lua",
      -- Only required if using match_algorithm fzf
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
      { "nvim-telescope/telescope-fzy-native.nvim" },
    },
  },

  {
    "folke/trouble.nvim",
    event = "VeryLazy",
    cmd = { "Trouble" },
    opts = { modes = {
      lsp = {
        win = { position = "right" },
      },
    } },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous Trouble/Quickfix Item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next Trouble/Quickfix Item",
      },
    },
  },

  {
    "DrKJeff16/project.nvim",
    dependencies = { -- OPTIONAL
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "ibhagwan/fzf-lua",
    },

    ---@module 'project'
    ---@type Project.Config.Options
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    cond = vim.fn.has("nvim-0.11") == 1, -- RECOMMENDED
  },
}
