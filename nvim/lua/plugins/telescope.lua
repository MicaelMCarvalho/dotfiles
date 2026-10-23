return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local actions = require('telescope.actions')

      local function middle_truncate_path(opts, path)
        local status = require('telescope.state').get_status(vim.api.nvim_get_current_buf())
        local results_win = status and status.results_win
        local available_width = results_win and vim.api.nvim_win_get_width(results_win) or 80

        if status and status.picker then
          available_width = available_width - vim.fn.strdisplaywidth(status.picker.selection_caret) - 2
        end
        available_width = available_width - (opts.__prefix or 0)

        if vim.fn.strdisplaywidth(path) <= available_width then
          return path
        end

        local separator = package.config:sub(1, 1)
        local absolute = path:sub(1, 1) == separator
        local parts = vim.split(path, separator, { plain = true, trimempty = true })

        if #parts < 3 then
          return path
        end

        local first = (absolute and separator or '') .. parts[1]
        local prefix = first .. separator .. '…' .. separator
        local suffix = parts[#parts]

        -- Preserve as many trailing directories as fit, plus the filename.
        for index = #parts - 1, 2, -1 do
          local candidate = parts[index] .. separator .. suffix
          if vim.fn.strdisplaywidth(prefix .. candidate) > available_width then
            break
          end
          suffix = candidate
        end

        return prefix .. suffix
      end

      -- Default mappings
      require('telescope').setup({
        defaults = {
          -- Keep normal path order and collapse only the middle when space is limited.
          path_display = middle_truncate_path,
          layout_strategy = 'horizontal', -- or 'vertical'
          layout_config = {
            horizontal = {
              width = 0.8,         -- 80% of screen width
              height = 0.8,        -- 80% of screen height
              preview_width = 0.4, -- 60% of width for preview panel
            },
            vertical = {
              width = 0.8,
              height = 0.8,
              preview_height = 0.5, -- 50% of height for preview panel
            },
          },
          mappings = {
            i = {
              ["<leader><Left>"] = actions.results_scrolling_left,
              ["<leader><Right>"] = actions.results_scrolling_right,
            },
            n = {
              ["<leader><Left>"] = actions.results_scrolling_left,
              ["<leader><Right>"] = actions.results_scrolling_right,
            },

          }
        }
      })

      local builtin = require('telescope.builtin')

      local function send_selected_to_qflist_and_open(prompt_bufnr)
        local selection = require('telescope.actions.state').get_selected_entry(prompt_bufnr)
        require('telescope.actions').send_to_qflist(prompt_bufnr, selection.value)
        require('telescope.actions').open_qflist()
      end

      vim.keymap.set('n', '<leader>pr', builtin.resume, { desc = 'Telescope: Resume last list' })
      -- vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
      vim.keymap.set('n', '<leader>pf', function()
        require('telescope.builtin').find_files({
          file_ignore_patterns = { "venv/" },
        })
      end, { desc = 'Telecope: Find files' })
      vim.keymap.set('n', '<leader>tt', '<cmd>Telescope<CR>', { desc = 'telescope: Menu' })
      vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Telescope: Git files' })
      -- vim.keymap.set('i', '<C-w>', send_selected_to_qflist_and_open,
      --   { desc = 'Telescope: Send selected to qflist and open' })
      vim.keymap.set('n', '<leader>ps', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") });
      end, { desc = 'Telescope: Grep string' })
      vim.keymap.set('n', '<leader>lg', function()
        require('telescope.builtin').live_grep({
          file_ignore_patterns = { "venv/" },
        })
      end, { desc = 'Telecope: Live grep' })
      vim.keymap.set('n', '<leader>bf', builtin.buffers, { desc = 'Telescope: Buffers' })
      vim.keymap.set('n', '<leader>pu', function()
        local current_word = vim.fn.expand("<cword>")
        require('telescope.builtin').grep_string({
          search = current_word,
          file_ignore_patterns = { "venv/" }
        })
      end, { desc = "Search for the word under cursor" })

      vim.keymap.set('v', '<leader>pu', function()
        vim.cmd('normal! "vy')
        local selected_text = vim.fn.getreg('v')
        require('telescope.builtin').grep_string({
          search = selected_text,
          file_ignore_patterns = { "venv/" }
        })
        vim.cmd('normal! <esc>')
      end, { desc = "Search for the selected text" })


      vim.api.nvim_set_keymap('n', '<leader>tr', '<cmd>Telescope resume<CR>',
        { noremap = true, silent = true, desc = 'Resume last telescope list' })
      vim.api.nvim_set_keymap('n', '<leader>tk', [[:Telescope keymaps<CR>]],
        { noremap = true, silent = true, desc = 'Show keymaps' })
      vim.api.nvim_set_keymap('v', '<leader>tk', [[:Telescope keymaps<CR>]],
        { noremap = true, silent = true, desc = 'Show keymaps' })

      vim.keymap.set('n', '<leader>te', function()
        require('telescope.builtin').diagnostics({
          severity = vim.diagnostic.severity.ERROR
        })
      end, { desc = "Search for errors in the current buffers" })
      vim.keymap.set('n', '<leader>ed', function()
        require('telescope.builtin').diagnostics({
        })
      end, { desc = "Search for diagnostics in the current buffers" })

      vim.keymap.set('n', '<leader>pe', function()
        require('telescope.builtin').diagnostics({
          severity = vim.diagnostic.severity.ERROR,
          root_dir = vim.uv.cwd()
        })
      end, { desc = "Search for errors in the entire project" })
      vim.keymap.set('n', '<leader>pE', function()
        require('telescope.builtin').diagnostics({
          severity = vim.diagnostic.severity.ERROR
        })
      end, { desc = "Search for errors across all workspaces" })

      vim.keymap.set('n', '<leader>pw', function()
        require('telescope.builtin').diagnostics({
          severity = vim.diagnostic.severity.WARN,
          root_dir = vim.uv.cwd()
        })
      end, { desc = "Search for warnings in the entire project" })
      vim.keymap.set('n', '<leader>pW', function()
        require('telescope.builtin').diagnostics({
          root_dir = vim.uv.cwd()
        })
      end, { desc = "Search for diagnostics in the entire project" })
      vim.keymap.set('n', '<leader>ts', builtin.lsp_document_symbols, { desc = 'Telescope: Search lsp document symbols' })
    end,
  },
  {
    "1riz/telescope-macros.nvim",
    config = function()
      require("telescope").load_extension "macros"
      vim.keymap.set("n", "<space>m<space>", "<cmd>Telescope macros<cr>")
      require('telescope').setup({
        extensions = {
          macros = {
            prompt_title = "Macros",
            num_registers = 50,
            letter_registers = true,
            theme = "dropdown",
            layout_strategy = "center",
            layout_config = {
              height = 0.20,
              width = 0.50
            }
          }
        }
      })
    end,
  }
}


--   mappings = {
--     i = {
--       ["<C-x>"] = actions.select_horizontal,
--       ["<C-v>"] = actions.select_vertical,
--       ["<C-t>"] = actions.select_tab
--     },
--     n = {
--       ["<C-x>"] = actions.select_horizontal,
--       ["<C-v>"] = actions.select_vertical,
--       ["<C-t>"] = actions.select_tab
--     }
--   }
-- },
-- extensions = {
--   advanced_git_search = {
--     diff_plugin = "fugitive",
--     git_flags = {},
--     git_diff_flags = {},
--     show_builtin_git_pickers = true,
--     entry_default_author_or_date = "author",
--     telescope_theme = {
--       function_name_1 = {},
--       function_name_2 = "dropdown",
--       show_custom_functions = {
--         layout_config = { width = 0.4, height = 0.4 },
--       },
--     }
--   }
-- }
-- require("telescope").load_extension("advanced_git_search")
-- require("telescope").load_extension("flutter")
-- keys = {
--   { "i<C-w>", send_selected_to_qflist_and_open, desc = "Telescope: Send selected to qflist and open", mode = 'i' },
--   { "<leader>tgl", '<cmd>AdvancedGitSearch diff_commit_line<CR>', desc = "AdvancedGitSearch: Search for commit by line", mode = {'n', 'x'} },
--   { "<leader>tgf", '<cmd>AdvancedGitSearch diff_commit_file<CR>', desc = "AdvancedGitSearch: Search for commit by file", mode = {'n', 'x'} },
--   { "<leader>te", function() require('telescope.builtin').diagnostics({ severity = vim.diagnostic.severity.ERROR }) end, desc = "Telescope: Search for errors in the current buffers" },
--   { "<leader>ed", function() require('telescope.builtin').diagnostics() end, desc = "Telescope: Search for diagnostics in the current buffers" },
