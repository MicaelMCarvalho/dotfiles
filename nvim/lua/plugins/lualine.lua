return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    config = function()

      -- load lualine with the options
      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = 'everforest',
          color = nil,
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {
            'nvimtree',
            'vista',
            'dbui',
          },
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {
            {
              'filename',
              file_status = true, -- displays file status (readonly status, modified status)
              path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
            },
          },
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {
            {
              'mode',
            },
          },
          lualine_b = {},
          lualine_c = {
            {
              'filename',
              file_status = true, -- displays file status (readonly status, modified status)
              path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
            },
          },
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        tabline = {
          lualine_a = {'buffers'},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        winbar = {},
        extensions = {},
      })

      -- set blend for the status line
      vim.cmd([[
        highlight statusline guibg=#1e1e2e guifg=#ffffff blend=30
        highlight statuslinenc guibg=#1e1e2e guifg=#aaaaaa blend=30
      ]])

      -- optional: set blend for lualine sections if needed
      vim.api.nvim_exec([[
        augroup lualineblend
          autocmd!
          autocmd colorscheme * highlight statusline guibg=#1e1e2e guifg=#ffffff blend=30
          autocmd colorscheme * highlight statuslinenc guibg=#1e1e2e guifg=#aaaaaa blend=30
        augroup end
      ]], false)

    end,
  }
}

