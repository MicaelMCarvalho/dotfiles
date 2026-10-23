return {
  {
    "j-morano/buffer_manager.nvim",
    lazy = true,
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>bb", ':lua require("buffer_manager.ui").toggle_quick_menu()<CR>', mode = "n", noremap = true, silent = true, desc = 'Toggle buffer manager' },
      { "<leader>bd", ':lua require("buffer_manager.ui").delete_buffer()<CR>', mode = "n", noremap = true, silent = true, desc = 'Delete buffer' },
      { "<leader>ba", ':lua require("buffer_manager.ui").delete_all_buffers()<CR>', mode = "n", noremap = true, silent = true, desc = 'Delete all buffers' },
      { "<leader>bs", ':lua require("buffer_manager.ui").search_buffer()<CR>', mode = "n", noremap = true, silent = true, desc = 'Search buffer' },
      { "<leader>bl", ':lua require("buffer_manager.ui").list_buffers()<CR>', mode = "n", noremap = true, silent = true, desc = 'List buffers' },
      { "<leader>bn", ':lua require("buffer_manager.ui").nav_next()<CR>', mode = "n", noremap = true, silent = true, desc = 'Navigate to next buffer' },
      { "<leader>bp", ':lua require("buffer_manager.ui").nav_prev()<CR>', mode = "n", noremap = true, silent = true, desc = 'Navigate to previous buffer' },
    }
  }
}
