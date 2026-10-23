return {
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      numhl = true,
      linehl = false,
      word_diff = false,
      signcolumn = true,
      sign_priority = 6,
      current_line_blame_opts = {
        delay = 2000,
        virt_text_pos = "eol",
      },
    },
    config = function()
      require("gitsigns").setup()
      vim.api.nvim_set_hl(0, 'GitSignsAdd', { link = 'DiffAdd' })
      vim.api.nvim_set_hl(0, 'GitSignsAddNr', { link = 'DiffAdd' })
      vim.api.nvim_set_hl(0, 'GitSignsChange', { link = 'DiffChange' })
      vim.api.nvim_set_hl(0, 'GitSignsChangeNr', { link = 'DiffChange' })
      vim.api.nvim_set_hl(0, 'GitSignsChangedelete', { link = 'DiffChangeDelete' })
      vim.api.nvim_set_hl(0, 'GitSignsChangedeleteNr', { link = 'DiffChangeDelete' })
      vim.api.nvim_set_hl(0, 'GitSignsDelete', { link = 'DiffDelete' })
      vim.api.nvim_set_hl(0, 'GitSignsDeleteNr', { link = 'DiffDelete' })
      vim.api.nvim_set_hl(0, 'GitSignsTopdelete', { link = 'DiffDelete' })
      vim.api.nvim_set_hl(0, 'GitSignsTopdeleteNr', { link = 'DiffDelete' })
    end,
  }
}
