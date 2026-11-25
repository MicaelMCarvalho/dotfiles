return {
  "yousefhadder/markdown-plus.nvim",
  ft = "markdown",

  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("MarkdownEnter", { clear = true }),
      pattern = "markdown",
      callback = function(event)
        -- Avoid markdown-plus's fallback to autoclose's expression mapping,
        -- which can swallow Enter outside lists. Keep a native newline here.
        vim.keymap.set("i", "<CR>", "<CR>", {
          buffer = event.buf,
          desc = "Insert newline",
        })
      end,
    })
  end,

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
