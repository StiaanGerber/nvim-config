-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle Comment" })
map("v", "<leader>/", "gc", { remap = true, desc = "Toggle Comment" })

map("n", "Y", "yy", { remap = true, desc = "Yank entire line" })


map("n", "<leader>e", function()
  -- Fetch the active explorer picker
  local explorer = Snacks.picker.get({ source = "explorer" })[1]
  
  if explorer then
    local current_win = vim.api.nvim_get_current_win()
    
    -- Check if the currently focused window is either the explorer's list or input window
    local is_list_focused = explorer.list and explorer.list.win and explorer.list.win.win == current_win
    local is_input_focused = explorer.input and explorer.input.win and explorer.input.win.win == current_win
    
    if is_list_focused or is_input_focused then
      -- If we are already inside the explorer, close it
      explorer:close()
    else
      -- If it's open but we are in another buffer, jump to it
      explorer.list.win:focus() 
    end
  else
    -- Open the explorer if it doesn't exist at all
    Snacks.explorer()
  end
end, { desc = "Explorer: Smart Toggle/Focus" })
