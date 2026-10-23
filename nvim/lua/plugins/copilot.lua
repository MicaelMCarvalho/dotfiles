return {
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true

      vim.keymap.set('i', '<C-i>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = "Accept the current suggestion"
      })
      vim.g.copilot_no_tab_map = true

      vim.keymap.set('i', '<Tab>', function()
        if vim.fn.pumvisible() == 1 then
          return '<C-n>'
        end
        return '<Tab>'
      end, { expr = true, silent = true })
    end,
    keys = {
      { "<C-,>", "<Plug>(copilot-dismiss)", mode = {"i"}, desc = "Dismiss the current suggestion" },
      { "<C-m>", "<Plug>(copilot-next)", mode = {"i"}, desc = "Cycle to the next suggestion" },
      { "<C-l>", "<Plug>(copilot-previous)", mode = {"i"}, desc = "Cycle to the previous suggestion" },
      { "<C-j>", "<Plug>(copilot-accept-word)", mode = {"i"}, desc = "Accept the next word of the current suggestion" },
      { "<C-k>", "<Plug>(copilot-accept-line)", mode = {"i"}, desc = "Accept the next line of the current suggestion" },
    }
  }
}
