return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "gf",         "<cmd>Obsidian follow_link<cr>",         mode = "n", desc = "Obsidian: Follow link under cursor" },
    { "<leader>0n", "<cmd>Obsidian new<cr>",                 mode = "n", desc = "Obsidian: create new note" },
    { "<leader>0l", "<cmd>Obsidian link<cr>",                mode = "n", desc = "Obsidian: create new link" },
    { "<leader>0k", "<cmd>Obsidian workspace work<cr>",      mode = "n", desc = "Obsidian: switch to work workspace" },
    { "<leader>0f", "<cmd>Obsidian search<cr>",              mode = "n", desc = "Obsidian: Search in notes" },
    { "<leader>0q", "<cmd>Obsidian quick_switch<cr>",        mode = "n", desc = "Obsidian: Quick Switch" },
    { "<leader>0w", "<cmd>Obsidian workspace<cr>",           mode = "n", desc = "Obsidian: List and switch workspaces" },
    { "<leader>0p", "<cmd>Obsidian workspace personal<cr>", mode = "n", desc = "Obsidian: Switch to personal workspace" },
  },
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "personal",
        path = "/Users/micael/Library/CloudStorage/GoogleDrive-micael.l.m.c@gmail.com/My Drive/Obsidian/Diary",
      },
      {
        name = "work",
        path = "/Users/micael/Library/CloudStorage/GoogleDrive-micael.l.m.c@gmail.com/My Drive/Obsidian/MintT",
        -- overrides = {
        --   completion = {
        --     nvim_cmp = true,
        --     min_chars = 3,
        --   },
        -- },
      },
    },
    completion = {
      min_chars = 2,
    },

    note_id_func = function(title)
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

    open_notes_in_current_window = false,
    prefer_link_text_as_title = true,

  },
}
