return {
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = {
      {
        "<leader>u",
        function()
          vim.cmd.UndotreeToggle()
          vim.defer_fn(function()
            vim.cmd("UndotreeFocus")
          end, 50)
        end,
        mode = { "n" },
        desc = "Toggle undotree"
      }
    }
  }
}
