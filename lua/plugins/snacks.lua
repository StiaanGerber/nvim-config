return {
  {
    "folke/snacks.nvim",
    -- keys = {
    --   {
    --     "<leader>e",
    --     function()
    --       -- Check if there are any active explorer pickers
    --       local explorer = Snacks.picker.get({ source = "explorer" })
    --
    --       if #explorer > 0 then
    --         -- If it exists, simply focus the first one found
    --         explorer[1]:focus()
    --       else
    --         -- If it doesn't exist, open it
    --         Snacks.explorer()
    --       end
    --     end,
    --     desc = "Open or Focus Explorer",
    --   },
    -- },
    opts = {
      terminal = {
        win = {
          style = "terminal",
          position = "float",
          relative = "editor",
          width = 0.95,
          height = 0.95,
          border = "rounded",
        },
      },
    },
    -- opts = {
    --   styles = {
    --     terminal = {
    --       position = "float",
    --       relative = "editor",
    --       width = 0.95,
    --       height = 0.95,
    --       border = "rounded",
    --       zindex = 250,
    --       title_pos = "center", -- Optional: centers the heading nicely!
    --     },
    --   },
    -- },
  },
}
