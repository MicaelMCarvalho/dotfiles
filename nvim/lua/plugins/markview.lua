return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<leader>vp",
      "<cmd>Markview Toggle<cr>",
      desc = "Markdown: Toggle inline preview",
    },
    {
      "<leader>vs",
      "<cmd>Markview splitToggle<cr>",
      desc = "Markdown: Toggle split preview",
    },
  },
  opts = {
    preview = {
      hybrid_modes = { "n" },
    },
    experimental = {
      check_rtp_message = false,
    },
  },
}
