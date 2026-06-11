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
    -- opts = {
    --   terminal = {
    --     win = {
    --       style = "terminal",
    --       position = "float",
    --       relative = "editor",
    --       width = 0.95,
    --       height = 0.95,
    --       border = "rounded",
    --     },
    --   },
    -- },
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

      -- https://github.com/folke/snacks.nvim/discussions/1748
      picker = {
        actions = {
          explorer_copy_default = function(picker, item)
            if not item then
              return
            end
            local Tree = require("snacks.explorer.tree")
            local actions = require("snacks.explorer.actions")
            local uv = vim.uv or vim.loop
            ---@type string[]
            local paths = vim.tbl_map(Snacks.picker.util.path, picker:selected())
            -- Copy selection
            if #paths > 0 then
              local dir = picker:dir()
              Snacks.picker.util.copy(paths, dir)
              picker.list:set_selected() -- clear selection
              Tree:refresh(dir)
              Tree:open(dir)
              actions.update(picker, { target = dir })
              return
            end
            Snacks.input({
              prompt = "Copy to",
              default = vim.fn.fnamemodify(item.file, ":t"),
            }, function(value)
              if not value or value:find("^%s$") then
                return
              end
              local dir = vim.fs.dirname(item.file)
              local to = svim.fs.normalize(dir .. "/" .. value)
              if uv.fs_stat(to) then
                Snacks.notify.warn("File already exists:\n- `" .. to .. "`")
                return
              end
              Snacks.picker.util.copy_path(item.file, to)
              Tree:refresh(vim.fs.dirname(to))
              actions.update(picker, { target = to })
            end)
          end,

          explorer_paste_rename = function(picker)
            local Tree = require("snacks.explorer.tree")
            local actions = require("snacks.explorer.actions")
            local files = vim.split(vim.fn.getreg(vim.v.register or "+") or "", "\n", { plain = true })
            files = vim.tbl_filter(function(file)
              return file ~= "" and vim.fn.filereadable(file) == 1
            end, files)

            if #files == 0 then
              return Snacks.notify.warn(("The `%s` register does not contain any files"):format(vim.v.register or "+"))
            elseif #files == 1 then
              local file = files[1]
              local base = vim.fn.fnamemodify(file, ":t")
              local dir = picker:dir()
              Snacks.input({
                prompt = "Rename pasted file",
                default = base,
              }, function(value)
                if not value or value:find("^%s*$") then
                  return
                end
                local uv = vim.uv or vim.loop
                local target = vim.fs.normalize(dir .. "/" .. value)
                if uv.fs_stat(target) then
                  return Snacks.notify.warn("File already exists:\n- `" .. target .. "`")
                end
                Snacks.picker.util.copy_path(file, target)
                Tree:refresh(dir)
                Tree:open(dir)
                actions.update(picker, { target = target })
              end)
            else
              local dir = picker:dir()
              local uv = vim.uv or vim.loop
              for _, file in ipairs(files) do
                local base = vim.fn.fnamemodify(file, ":t")
                local target = vim.fs.normalize(dir .. "/" .. base)
                local name, ext = base:match("^(.*)%.(.*)$")
                name = name or base
                ext = ext and ("." .. ext) or ""

                local count = 1
                while uv.fs_stat(target) do
                  target = vim.fs.normalize(dir .. "/" .. name .. "_" .. count .. ext)
                  count = count + 1
                end

                Snacks.picker.util.copy_path(file, target)
              end
              Tree:refresh(dir)
              Tree:open(dir)
              actions.update(picker, { target = dir })
            end
          end,
        },

        sources = {
          explorer = {
            win = {
              list = {
                keys = {
                  ["R"] = "explorer_paste_rename",
                  ["C"] = "explorer_copy_default",
                },
              },
            },
          },
        },
    },
  }
  },
}
