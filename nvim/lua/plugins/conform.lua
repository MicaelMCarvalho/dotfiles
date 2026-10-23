return {
  "stevearc/conform.nvim",

  event = { "BufWritePre" },
  cmd = { "ConformInfo" },

  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({
          async = true,
          lsp_format = "fallback",
        })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },

    -- Optional: apply all safe Ruff fixes to a Python file.
    {
      "<leader>cf",
      function()
        if vim.bo.filetype ~= "python" then
          vim.notify(
            "Ruff fixes are only available for Python files",
            vim.log.levels.WARN
          )
          return
        end

        require("conform").format({
          async = true,
          formatters = { "ruff_fix", "ruff_format" },
        })
      end,
      mode = "n",
      desc = "Ruff fix and format",
    },
  },

  opts = {
    formatters_by_ft = {
      lua = { "stylua" },

      -- Ruff replaces isort + Black.
      -- 1. Sort and organize imports
      -- 2. Format the Python source
      python = {
        "ruff_organize_imports",
        "ruff_format",
      },

      -- Run prettierd when available; otherwise use prettier.
      javascript = {
        "prettierd",
        "prettier",
        stop_after_first = true,
      },
      javascriptreact = {
        "prettierd",
        "prettier",
        stop_after_first = true,
      },
      typescript = {
        "prettierd",
        "prettier",
        stop_after_first = true,
      },
      typescriptreact = {
        "prettierd",
        "prettier",
        stop_after_first = true,
      },

      dart = { "dart_format" },

      dockerfile = { "beautysh" },

      ["docker-compose"] = { "yamlfix" },
      yaml = { "yamlfix" },

      markdown = { "markdownlint-cli2" },

      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
    },

    -- Keep saves free of unrelated formatting changes. Format explicitly with
    -- <leader>f (including a visual selection for range formatting).
    format_on_save = false,

    default_format_opts = {
      lsp_format = "fallback",
      timeout_ms = 3000,
    },

    notify_on_error = true,
    notify_no_formatters = true,

    formatters = {
      -- Ruff installed with:
      --   brew install ruff
      --
      -- "ruff" is resolved from PATH, so no hardcoded path is needed.
      ruff_format = {
        command = "ruff",
      },
      ruff_organize_imports = {
        command = "ruff",
      },
      ruff_fix = {
        command = "ruff",
      },

      yamlfix = {
        command = vim.fn.expand(
          "~/.venv/nvim-format/bin/yamlfix"
        ),
      },

      beautysh = {
        command = vim.fn.expand(
          "~/.venv/nvim-format/bin/beautysh"
        ),
      },

      shfmt = {
        prepend_args = {
          "-i",
          "2",
          "-ci",
          "-sr",
        },
      },
    },
  },

  init = function()
    vim.o.formatexpr =
    "v:lua.require'conform'.formatexpr()"
  end,
}
