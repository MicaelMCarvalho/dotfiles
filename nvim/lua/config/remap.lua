-- Set the leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set macro key to \
vim.keymap.set('n', '\\', '@', { noremap = true, desc = "Macro key" })
vim.keymap.set('n', ',', '@@', { noremap = true, desc = "Repeat last macro" })

-- Map <leader>pv to execute a vim command
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Vim File Explorer" })

-- In visual mode, move selected lines down with J
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down with J" })
-- In visual mode, move selected lines up with K
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up with K" })

vim.api.nvim_set_keymap('n', '<leader>s2', [[:set softtabstop=2 shiftwidth=2 tabstop=2<CR>]],
  { noremap = true, silent = true, desc = 'Set softtabstop, shiftwidth, and tabstop to 2' })
vim.api.nvim_set_keymap('n', '<leader>s4', [[:set softtabstop=4 shiftwidth=4 tabstop=4<CR>]],
  { noremap = true, silent = true, desc = 'Set softtabstop, shiftwidth, and tabstop to 4' })
vim.api.nvim_set_keymap('n', '<leader>sc', [[:set conceallevel=0<CR>]],
  { noremap = true, silent = true, desc = 'Set conceallevel to 0' })
vim.api.nvim_set_keymap('n', '<leader>js', [[:%!python -m json.tool<CR>]],
  { noremap = true, silent = true, desc = 'Format the entire buffer as JSON' })

-- In normal mode, join lines with J and return to initial position
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines with J and return to initial position" })

-- In normal mode, scroll down half a page and center cursor line
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half a page and center cursor line" })

-- In normal mode, scroll up half a page and center cursor line
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half a page and center cursor line" })

-- In normal mode, find next match and center cursor line
vim.keymap.set("n", "n", "nzzzv", { desc = "Find next match and center cursor line" })

-- In normal mode, find previous match and center cursor line
vim.keymap.set("n", "N", "Nzzzv", { desc = "Find previous match and center cursor line" })

-- In visual mode, paste before selection and keep selection
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste before selection and keep selection" })

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })

-- Yank to end of line to system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank to end of line to system clipboard" })

-- In insert mode, map Ctrl-c to Escape
vim.keymap.set("i", "<C-c>", "<Esc>", {
  noremap = true,
  silent = true,
  nowait = true,
  desc = "Map Ctrl-c to Escape",
})

-- Disable Q command in normal mode
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Q command in normal mode" })

-- Open a new tmux window with tmux-sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>",
  { desc = "Open a new tmux window with tmux-sessionizer" })
--
-- Format buffer


-- vim.keymap.set("n", "<leader>f", function()
--   if vim.lsp.buf.server_capabilities.documentFormattingProvider then
--     vim.lsp.buf.format()
--   else
--     print("LSP does not support formatting for this file.")
--   end
-- end, { desc = "Format buffer" })


-- Go to next error and center cursor line
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Go to next error and center cursor line" })

-- Go to previous error and center cursor line
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Go to previous error and center cursor line" })

-- -- Go to next location and center cursor line
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Go to next location and center cursor line" })
--
-- -- Go to previous location and center cursor line
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Go to previous location and center cursor line" })

-- Search and replace current word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Search and replace current word under cursor" })

-- Keep this separate from the register-preserving delete mapping on <leader>x.
vim.keymap.set("n", "<leader>cx", "<cmd>!chmod +x %<CR>",
  { silent = true, desc = "Make current file executable" })

-- Source current file
vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end, { desc = "Source current file" })

-- Format buffer as JSON
vim.keymap.set("n", "<leader>jt", ":bufdo %!python -m json.tool<CR>",
  { silent = true, desc = "Format all buffers as JSON" })

-- Delete without yanking
vim.keymap.set("n", "d", '"_d')
vim.keymap.set("n", "x", '"_x')
vim.keymap.set("n", "D", '"_D')

-- Delete and yank to unnamed register
vim.keymap.set("n", "<leader>d", '""d')
vim.keymap.set("n", "<leader>x", '""x')
vim.keymap.set("n", "<leader>D", '""D')

-- In visual mode, delete without yanking
vim.keymap.set("v", "d", '"_d')
vim.keymap.set("v", "x", '"_x')
vim.keymap.set("v", "D", '"_D')

-- In visual mode, delete and yank to unnamed register
vim.keymap.set("v", "<leader>d", '""d')
vim.keymap.set("v", "<leader>x", '""x')
vim.keymap.set("v", "<leader>D", '""D')

-- In visual mode, run normal mode command on selection
vim.keymap.set("v", "<leader>n", ":norm", { desc = "Run normal mode command on selection" })

vim.keymap.set("n", "<leader>z", ":noh<CR>", { desc = "Clear search highlights" })

vim.keymap.set("n", "<leader>yf", ":let @+ = expand('%:p')<CR>",
  { desc = "Put the full path of the current file in the system clipboard" })

vim.keymap.set("n", "<leader>l", function()
  vim.diagnostic.open_float({ scope = "line" })
end, { desc = "Open line diagnostic float" })

vim.keymap.set('v', '<leader>2x', ":'<,'>norm 0xx<CR>", { desc = "Execute :'<,'>norm 0xx in visual mode" })
vim.keymap.set('v', '<leader>4x', ":'<,'>norm 0xxxx<CR>", { desc = "Execute :'<,'>norm 0xxxx in visual mode" })

vim.keymap.set('v', '<leader>2a', ":'<,'>norm 0i  <CR>",
  { desc = "Execute :'<,'>norm add 2 spaces start in visual mode" })
vim.keymap.set('v', '<leader>4a', ":'<,'>norm 0i    <CR>",
  { desc = "Execute :'<,'>norm add 4 spaces start invisual mode" })
--
-- Insert opening JSX comment in normal mode
vim.keymap.set('n', '<leader>{', 'i{/* <Esc>', { desc = "Insert JSX comment opening" })

-- Insert closing JSX comment in normal mode
vim.keymap.set('n', '<leader>}', 'a */}<Esc>', { desc = "Insert JSX comment closing" })

vim.keymap.set('n', '<leader>ra', ':registers 0123456789abcdefghijklmnopqrstuvwxyz<CR>',
  { desc = "Show all numbered and letter registers macros" })

vim.keymap.set('n', '<leader>dr', function()
  for i = string.byte('a'), string.byte('z') do
    vim.fn.setreg(string.char(i), '')
  end
  for i = 0, 9 do
    vim.fn.setreg(tostring(i), '')
  end
  print("All registers cleared")
end, { desc = "Delete all registers" })

vim.keymap.set('n', '<leader>dc', function()
  vim.ui.input({
    prompt = "Enter register to clear (0-9 or a-z): ",
  }, function(input)
    if input then
      -- Check if input is valid
      if string.match(input, "^[0-9a-z]$") then
        vim.fn.setreg(input, '')
        print("Register '" .. input .. "' cleared")
      else
        print("Invalid register. Use 0-9 or a-z")
      end
    end
  end)
end, { desc = "Delete specific register" })


local map = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { noremap = true, silent = true, desc = desc })
end

map('za', '<Cmd>normal! za<CR>', 'Toggle fold under cursor')
map('zc', '<Cmd>normal! zc<CR>', 'Close fold under cursor')
map('zo', '<Cmd>normal! zo<CR>', 'Open fold under cursor')
map('zC', '<Cmd>normal! zC<CR>', 'Close all folds recursively under cursor')
map('zO', '<Cmd>normal! zO<CR>', 'Open all folds recursively under cursor')
map('zR', '<Cmd>normal! zR<CR>', 'Open all folds in buffer')
map('zM', '<Cmd>normal! zM<CR>', 'Close all folds in buffer')
map('zm', '<Cmd>normal! zm<CR>', 'Reduce foldlevel by 1 (more folds closed)')
map('zr', '<Cmd>normal! zr<CR>', 'Increase foldlevel by 1 (more folds open)')
map('zv', '<Cmd>normal! zv<CR>', 'Open folds just enough to show the cursor line')
map('zx', '<Cmd>normal! zx<CR>', 'Update folds & view according to settings')
map('zd', '<Cmd>normal! zd<CR>', 'Delete fold at cursor')
map('zE', '<Cmd>normal! zE<CR>', 'Delete all folds in buffer')

-- zf{motion} alternative, so it shows in Telescope
vim.keymap.set('n', '<leader>zf', function()
  vim.api.nvim_feedkeys('zf', 'n', false)
end, { desc = 'Create a manual fold (then give a motion)' })



-- Save registers/macros/etc. to ShaDa
vim.keymap.set("n", "<leader>ms", "<Cmd>wshada<CR>", {
  desc = "Save ShaDa (persist registers/macros)"
})

-- Reload registers/macros/etc. from ShaDa
vim.keymap.set("n", "<leader>mr", "<Cmd>rshada<CR>", {
  desc = "Reload ShaDa (restore registers/macros)"
})



vim.keymap.set("n", "<leader>pt", function()
  require("telescope.builtin").live_grep({
    search_dirs = { "./node_modules/tailwindcss" },
  })
end, { desc = "Search Tailwind docs (live_grep)" })


vim.keymap.set("n", "<leader>vg", function()
  if vim.bo.filetype ~= "markdown" then
    vim.notify("Go-Grip preview is only available for Markdown files", vim.log.levels.WARN)
    return
  end

  if vim.fn.executable("go-grip") ~= 1 then
    vim.notify("go-grip is not installed or not on PATH", vim.log.levels.ERROR)
    return
  end

  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("Save the buffer before starting Go-Grip", vim.log.levels.WARN)
    return
  end

  vim.cmd.write()
  vim.fn.jobstart({ "go-grip", file, "--browser" }, {
    detach = true,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.schedule(function()
          vim.notify("Go-Grip exited with code " .. exit_code, vim.log.levels.ERROR)
        end)
      end
    end,
  })
end, { desc = "Markdown: Preview current buffer with Go-Grip" })
