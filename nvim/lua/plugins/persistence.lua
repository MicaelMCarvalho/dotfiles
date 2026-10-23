return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    lazy = false,
    opts = {
        -- Set to 0 to always save
        need = 0,
        branch = true, -- use git branch to save session
    },
    config = function()
      require("persistence").setup()
      -- load the session for the current directory
      vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end, { desc = "Load session for current directory" })

      -- select a session to load
      vim.keymap.set("n", "<leader>qS", function() require("persistence").select() end, { desc = "Select a session to load" })

      -- load the last session
      vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Load the last session" })

      -- stop Persistence => session won't be saved on exit
      vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Stop Persistence (no session save)" })
    end,
  --   config = function()
  --     -- load the session for the current directory
  --     vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end, { desc = "Load session for current directory" })
  --
  --     -- select a session to load
  --     vim.keymap.set("n", "<leader>qS", function() require("persistence").select() end, { desc = "Select a session to load" })
  --
  --     -- load the last session
  --     vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Load the last session" })
  --
  --     -- stop Persistence => session won't be saved on exit
  --     vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Stop Persistence (no session save)" })
  --   end
  }
}
