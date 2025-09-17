return {
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    config = function()
      require("plugins.configs.luasnip")
    end,
    build = (not LazyVim.is_win())
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      -- Configure cmp to work w luasnip
      {
        "nvim-cmp",
        -- dependencies = {
        --   "saadparwaiz1/cmp_luasnip",
        -- },
        opts = function(_, opts)
          opts.snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          }
          table.insert(opts.sources, { name = "luasnip" })
          table.insert(opts.sources, { name = "emoji" })
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },

  -- Better TS error messages - for tsserver
  -- { "dmmulroy/ts-error-translator.nvim" },

  -- Map jj or jk to escape
  {
    "max397574/better-escape.nvim",
    event = "VeryLazy",
    opts = {
      timeout = vim.o.timeoutlen,
      default_mappings = true,
      mappings = {
        i = {
          j = {
            -- These can all also be functions
            k = "<Esc>",
            j = "<Esc>",
          },
        },
        c = {
          j = {
            k = "<Esc>",
            j = "<Esc>",
          },
        },
        t = {
          j = {
            k = "<Esc>",
            j = "<Esc>",
          },
        },
        v = {
          j = {
            k = "<Esc>",
          },
        },
        s = {
          j = {
            k = "<Esc>",
          },
        },
      },
    },
  },

  -- Switch between relative and absolute line numbers with ease
  { "cpea2506/relative-toggle.nvim" },

  -- Use the w, e, b motions like a spider. Move by subwords and skip insignificant punctuation.
  {
    "chrisgrieser/nvim-spider",
    event = "InsertEnter",
    config = function()
      require("spider").motion("e", {
        customPatterns = { "const .", "let .", "var ." },
      })
    end,
    opts = {
      skipInsignificantPunctuation = false,
      consistentOperatorPending = false, -- see "Consistent Operator-pending Mode" in the README
      subwordMovement = true,
      customPatterns = {}, -- check "Custom Movement Patterns" in the README for details
    },
    keys = {
      {
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
      },
    },
  },

  {
    "mawkler/demicolon.nvim",
    event = "InsertEnter",
    dependencies = {
      -- "jinh0/eyeliner.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    keys = { ";", ",", "t", "f", "T", "F", "]", "[", "]d", "[d" },
    opts = {},
  },
}
