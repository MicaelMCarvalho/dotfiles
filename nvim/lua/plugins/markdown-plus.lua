return {
  "yousefhadder/markdown-plus.nvim",
  ft = "markdown",

  opts = {
    enabled = true,

    features = {
      list_management = true,
      text_formatting = true,
      thematic_break = true,
      headers_toc = true,
      links = true,
      images = true,
      quotes = true,
      callouts = true,
      code_block = true,
      html_block_awareness = true,
      table = true,
      footnotes = true,
    },

    footnotes = {
      section_header = "Footnotes",
      confirm_delete = true,
    },

    keymaps = {
      enabled = true,
    },

    toc = {
      initial_depth = 2,
    },

    callouts = {
      default_type = "NOTE",
      custom_types = {},
    },

    table = {
      auto_format = true,
      default_alignment = "left",
      confirm_destructive = true,

      keymaps = {
        enabled = true,
        prefix = "<localleader>t",
        insert_mode_navigation = true,
      },
    },

    filetypes = { "markdown" },
  },
}
