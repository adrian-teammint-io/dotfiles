return {
  {
    "stevearc/oil.nvim",
    config = function()
      require("plugins.configs.oil")
    end,
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
