return {
  {
    "folke/flash.nvim",
    keys = {
      -- Disable the default flash keymap for 's'
      { "s", mode = { "n", "x", "o" }, false },
      -- Optionally, disable 'S' as well
      -- { "S", mode = { "n", "x", "o" }, false },
    },
  },
}

