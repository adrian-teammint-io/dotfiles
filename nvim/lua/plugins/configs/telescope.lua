local open_with_trouble = require("trouble.sources.telescope").open
local lst = require("telescope").extensions.luasnip
local luasnip = require("luasnip")

local telescope = require("telescope")
local actions = require("telescope.actions")
local config = require("telescope.config")
local builtin = require("telescope.builtin")
-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(config.values.vimgrep_arguments) }

-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup({
  defaults = {
    file_ignore_patterns = { "node_modules" },
    preview = {
      filesize_limit = 0.1, -- MB
    },
    -- `hidden = true` is not supported in text grep commands.
    vimgrep_arguments = vimgrep_arguments,
    layout_config = { prompt_position = "bottom" },
    mappings = {
      i = {
        ["<c-t>"] = open_with_trouble,
        ["<esc>"] = actions.close,
        ["<C-u>"] = false, -- clear prompt
        ["<c-d>"] = actions.delete_buffer + actions.move_to_top, -- delete a buffer from picker without closing telescope
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
      },
      n = { ["<c-t>"] = open_with_trouble },
    },
  },
  -- pickers = {
  --   find_files = { theme = "ivy", layout_config = { height = 0.4 } },
  --   oldfiles = { theme = "ivy", layout_config = { height = 0.6 } },
  --   git_files = { theme = "ivy", layout_config = { height = 0.4 } },
  --   live_grep = { theme = "ivy", layout_config = { height = 0.8 } },
  --   current_buffer_fuzzy_find = { theme = "ivy", layout_config = { height = 0.8 } },
  --   buffers = { theme = "ivy", layout_config = { height = 0.4 } },
  --   keymaps = { theme = "ivy", layout_config = { height = 0.4 } },
  --   file_browser = { theme = "ivy", layout_config = { height = 0.4 } },
  --   treesitter = { theme = "ivy", layout_config = { height = 0.4 } },
  --   help_tags = { theme = "ivy", layout_config = { height = 0.5 } },
  --   frecency = { theme = "ivy", layout_config = { height = 0.5 } },
  --   luasnip = { theme = "dropdown", layout_config = { height = 0.5 } },
  --   man_pages = {
  --     sections = { "1", "2", "3" },
  --     theme = "ivy",
  --     layout_config = { height = 0.4 },
  --   },
  -- },
  extensions = {
    luasnip = {
      search = function(entry)
        return lst.filter_null(entry.context.trigger)
          .. " "
          .. lst.filter_null(entry.context.name)
          .. " "
          .. entry.ft
          .. " "
          .. lst.filter_description(entry.context.name, entry.context.description)
          .. lst.get_docstring(luasnip, entry.ft, entry.context)[1]
      end,
    },
    undo = {
      mappings = {
        i = {
          ["<cr>"] = require("telescope-undo.actions").yank_additions,
          ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
          ["<C-cr>"] = require("telescope-undo.actions").restore,
          -- alternative defaults, for users whose terminals do questionable things with modified <cr>
          ["<C-y>"] = require("telescope-undo.actions").yank_deletions,
          ["<C-r>"] = require("telescope-undo.actions").restore,
        },
        n = {
          ["y"] = require("telescope-undo.actions").yank_additions,
          ["Y"] = require("telescope-undo.actions").yank_deletions,
          ["u"] = require("telescope-undo.actions").restore,
        },
      },
    },
    frecency = {
      -- absoulute | shorten | filename_first
      path_display = { "filename_first" },
      auto_validate = false,
      matcher = "fuzzy",
      default_workspace = "CWD",
      -- direction = "asc",
      order = "timestamps",
      -- show_scores = true,
      -- workspace_scan_cmd = "rg -.g '!.git' --files`",
      workspace_scan_cmd = "LUA",
      ignore_patterns = {
        "*/.git",
        "*/.git/*",
        "*/.DS_Store",
        "*/node_modules",
        "*/node_modules/*",
        "*/tmp/*",
        "term://*",
      },
    },
  },
})

telescope.load_extension("frecency")
telescope.load_extension("tailiscope")
telescope.load_extension("undo")
telescope.load_extension("luasnip")
telescope.load_extension("recent-files")
