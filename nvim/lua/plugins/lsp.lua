return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {},
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<leader>su"] = cmp.mapping.scroll_docs(-4),
          ["<leader>sd"] = cmp.mapping.scroll_docs(4),
          ["<C-f>"] = cmp.mapping(function(fallback)
            local luasnip = require("luasnip")
            if luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-b>"] = cmp.mapping(function(fallback)
            local luasnip = require("luasnip")
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sources = {
          { name = "nvim_lsp" },
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {},
        -- Servers below are enabled explicitly. Mason's default automatic
        -- enabling can otherwise attach another client with a different root.
        automatic_enable = false,
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local function definition_list(result)
        local unique = {}
        local seen = {}

        for _, item in ipairs(result.items) do
          local filename = item.filename
          if (not filename or filename == "") and item.bufnr and item.bufnr > 0 then
            filename = vim.api.nvim_buf_get_name(item.bufnr)
          end

          local key = table.concat({
            filename or "",
            item.lnum or 0,
            item.col or 0,
            item.end_lnum or 0,
            item.end_col or 0,
          }, ":")

          if not seen[key] then
            seen[key] = true
            unique[#unique + 1] = item
          end
        end

        vim.fn.setqflist({}, " ", {
          title = result.title or "LSP definitions",
          items = unique,
        })

        if #unique == 1 then
          vim.cmd("silent cfirst")
        else
          vim.cmd("botright copen")
        end
      end

      local function on_attach(_, bufnr)
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, {
            buffer = bufnr,
            silent = true,
            desc = "LSP: " .. desc,
          })
        end

        map("n", "gd", function()
          vim.lsp.buf.definition({
            reuse_win = true,
            on_list = definition_list,
          })
        end, "Go to definition")
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "<leader>vws", vim.lsp.buf.workspace_symbol, "Workspace symbol")
        map("n", "<leader>vd", vim.diagnostic.open_float, "Open diagnostic float")
        map("n", "<leader>ln", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, "Next diagnostic")
        map("n", "<leader>lp", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, "Previous diagnostic")
        map({ "n", "v" }, "<leader>vca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>vrr", vim.lsp.buf.references, "References")
        map("n", "<leader>vrn", vim.lsp.buf.rename, "Rename")
        map("i", "<C-h>", vim.lsp.buf.signature_help, "Signature help")
        map("n", "<leader>ll", function()
          vim.diagnostic.open_float({ scope = "line" })
        end, "Line diagnostics")
      end

      local common = {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      vim.lsp.config("lua_ls", vim.tbl_deep_extend("force", common, {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      }))

      for _, server in ipairs({ "ts_ls", "volar", "dartls", "marksman" }) do
        vim.lsp.config(server, common)
      end

      vim.lsp.config("tailwindcss", vim.tbl_deep_extend("force", common, {
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                "cva\\(([^)]*)\\)",
                "cn\\(([^)]*)\\)",
              },
            },
          },
        },
      }))

      vim.lsp.enable({
        "lua_ls",
        "ts_ls",
        "volar",
        "dartls",
        "marksman",
        "tailwindcss",
      })
    end,
  },

  {
    "esmuellert/nvim-eslint",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
    },
    opts = {},
  },
}
