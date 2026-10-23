return {
  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    keys = {
      { "<leader>o", "<CMD>Oil<CR>", mode = {"n", "v"}, desc = "oil open parent directory", },
    },
    default_file_explorer = false,
  }
}

