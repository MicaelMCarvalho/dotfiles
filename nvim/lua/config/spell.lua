local group = vim.api.nvim_create_augroup("user_spellcheck", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
    vim.opt_local.conceallevel = 2
  end,
})

vim.keymap.set("n", "<leader>us", function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
end, { desc = "Toggle spellcheck" })

vim.keymap.set("n", "<leader>sen", function()
  vim.opt_local.spelllang = "en_us"
end, { desc = "Set spell language to English" })

vim.keymap.set("n", "<leader>spt", function()
  vim.opt_local.spelllang = "pt_pt"
end, { desc = "Set spell language to Portuguese" })
