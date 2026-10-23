vim.cmd.colorscheme "catppuccin"

-- Set line numbers
vim.opt.nu = true

-- Set relative line numbers
vim.opt.relativenumber = true

-- Set tab width to 2 spaces
vim.opt.tabstop = 2

-- Set soft tab width to 2 spaces
vim.opt.softtabstop = 2

-- Set shift width (used for auto-indent) to 2 spaces
vim.opt.shiftwidth = 2

-- Convert tabs to spaces
vim.opt.expandtab = true

-- Enable smart indentation
vim.opt.smartindent = false

-- Disable line wrapping
vim.opt.wrap = false

-- Disable swap file creation
vim.opt.swapfile = false

-- Disable backup file creation
vim.opt.backup = false

-- Set the directory for undo files
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Enable persistent undo
vim.opt.undofile = true

-- Highlight search matches
vim.opt.hlsearch = true

-- Enable incremental search
vim.opt.incsearch = true

-- Enable true color support
vim.opt.termguicolors = true

-- Set scroll offset
vim.opt.scrolloff = 8

-- Always show the sign column
vim.opt.signcolumn = "yes"

-- Append '@-@' to the 'isfname' option (file name characters)
vim.opt.isfname:append("@-@")

-- Set the update time (in milliseconds)
vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "80" -- Set a vertical color column at 80 characters (commented out)


-- Enable the window title
vim.o.title = true

-- Set the window title to the full path of the current file's directory
vim.o.titlestring = "%{expand(\"%:p:h\")}"

-- Ignore case in search patterns
vim.opt.ignorecase = true

-- Override 'ignorecase' if search pattern contains uppercase letters
vim.opt.smartcase = true

-- -- Create an autocommand group for file type settings
-- vim.api.nvim_exec([[
--   augroup FileSettings
--     autocmd!
--     autocmd FileType vue,js setlocal tabstop=2 softtabstop=2 shiftwidth=2
--   augroup END
-- ]], false)

-- Disable syntax concealment in Markdown files
vim.g.markdown_syntax_conceal = 1

-- Disable syntax concealment in JSON files
vim.g.vim_json_conceal = 0

-- Set the Python 3 interpreter path
vim.g.python3_host_prog = '/usr/bin/python3'

-- Enable line wrapping and line breaking
vim.api.nvim_set_keymap('n', '<leader>slw', [[:set wrap linebreak<CR>]], {noremap = true, silent = true, desc = 'Enable line wrapping and line breaking' })

-- User commands

-- Toggle display of whitespace characters
vim.api.nvim_create_user_command(
  'ToggleWhitespace',
  'set list!',
  {desc = 'Toggle display of whitespace characters'}
)

-- Remove trailing whitespace from the document
vim.api.nvim_create_user_command(
  'RemoveTrailingSpaces',
  '%s/\\s\\+$//e',
  {desc = 'Remove trailing whitespace from the document'}
)

-- Set specific characters for tabs, trailing spaces, and end of line
vim.api.nvim_create_user_command(
  'SetListChars',
  'set list listchars=tab:>-,trail:·,eol:↲',
  {desc = 'Set specific characters for tabs, trailing spaces, and EOL'}
)

-- Reset list characters to default
vim.api.nvim_create_user_command(
  'ResetListChars',
  'set list listchars=',
  {desc = 'Reset list characters to default'}
)

-- vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- vim.o.sessionoptions = vim.o.sessionoptions .. ',localoptions'
--
-- Key mappings for user commands

-- Toggle display of whitespace characters
vim.api.nvim_set_keymap('n', '<leader>tw', ':ToggleWhitespace<CR>', { noremap = true, silent = true, desc = 'Toggle display of whitespace characters' })

-- Remove trailing whitespace
vim.api.nvim_set_keymap('n', '<leader>rs', ':RemoveTrailingSpaces<CR>', { noremap = true, silent = true, desc = 'Remove trailing whitespace from the document' })

-- Set specific characters for tabs, trailing spaces, and end of line
vim.api.nvim_set_keymap('n', '<leader>sel', ':SetListChars<CR>', { noremap = true, silent = true, desc = 'Set specific characters for tabs, trailing spaces, and EOL' })

-- Reset list characters to default
vim.api.nvim_set_keymap('n', '<leader>snel', ':ResetListChars<CR>', { noremap = true, silent = true, desc = 'Reset list characters to default' })

vim.g.netrw_list_hide = '^\\./\\S\\+,\\~$,\\.DS_Store$,\\.git$'
-- TRYING TO SET different tab steps depending on the path -- NOT WORKING
--local function set_tab_size()
--    local bufname = vim.fn.expand('%:p:h')
--    if string.find(bufname, 'MyISA') then
--        vim.opt.tabstop = 2
--        vim.opt.softtabstop = 2
--        vim.opt.shiftwidth = 2
--    else
--        vim.opt.tabstop = 4
--        vim.opt.softtabstop = 4
--        vim.opt.shiftwidth = 4
--    end
--end

--vim.cmd('autocmd BufEnter * lua set_tab_size()')
--vim.cmd('autocmd BufRead * lua set_tab_size()')


-- vim.opt.autoindent = true
-- vim.opt.smartindent = true
-- vim.opt.tabstop = 2
-- vim.opt.shiftwidth = 2
-- vim.opt.expandtab = true


-- vim.cmd([[
--   set cursorline
-- ]])
--
-- vim.cmd [[
-- ]]
--
-- vim.cmd [[
--   augroup CursorLine
--     autocmd!
--     autocmd WinEnter,BufEnter * setlocal cursorline
--     autocmd WinLeave,BufLeave * setlocal nocursorline
--   augroup END
-- ]]


-- Disable built-in SQL completion keymaps
vim.g.omni_sql_no_default_maps = 1
