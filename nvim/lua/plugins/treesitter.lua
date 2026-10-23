local languages = {
  "javascript",
  "typescript",
  "tsx",
  "html",
  "css",
  "python",
  "c",
  "lua",
  "vim",
  "vimdoc",
  "query",
  "rust",
  "dockerfile",
  "c_sharp",
  "vue",
  "markdown",
  "markdown_inline",
  "yaml",
  "go",
  "dart",
  "latex",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    -- The main branch explicitly does not support lazy-loading.
    lazy = false,
    -- Install/update parsers only when the plugin itself is installed or built,
    -- rather than checking all parsers on every Neovim startup.
    build = function()
      require("nvim-treesitter").install(languages):wait(300000)
    end,

    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        pattern = languages,
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
