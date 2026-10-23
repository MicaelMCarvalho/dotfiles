return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },

  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = function()
      return {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },
}
-- return {
--   {
--     "numToStr/Comment.nvim",
--     dependencies = {
--       "JoosepAlviste/nvim-ts-context-commentstring",
--     },
--     config = function()
--       require("ts_context_commentstring").setup({
--         enable_autocmd = false,
--       })
--
--       -- Basic Comment.nvim setup first
--       require("Comment").setup({
--         padding = true,
--         sticky = true,
--         ignore = nil,
--         toggler = {
--           line = 'gcc',
--           block = 'gbc',
--         },
--         opleader = {
--           line = 'gc',
--           block = 'gb',
--         },
--         -- Use the pre_hook for JSX style comments
--         pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
--       })
--
--       -- Set up autocommand for .tsx files
--       -- vim.api.nvim_create_autocmd("FileType", {
--       --   pattern = { "typescriptreact", "javascriptreact", "tsx", "jsx" },
--       --   callback = function()
--       --     vim.bo.commentstring = "{/* %s */}"
--       --   end,
--       -- })
--     end,
--   }
--
-- }
