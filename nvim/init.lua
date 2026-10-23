-- GUI launches do not always inherit NVM's PATH. Resolve NVM's default Node
-- version at startup instead of pinning a version directory.
if vim.fn.executable("node") == 0 then
  local node = vim.fn.system({
    "/bin/zsh",
    "-c",
    [[export NVM_DIR="$HOME/.nvm"; source "$NVM_DIR/nvm.sh" >/dev/null 2>&1 && command -v node]],
  }):gsub("%s+$", "")

  -- A lazy-loading shell function can make `command -v node` return just
  -- "node". Only add a real, absolute executable to PATH.
  if vim.v.shell_error == 0 and node:sub(1, 1) == "/" and vim.fn.executable(node) == 1 then
    vim.env.PATH = vim.fs.dirname(node) .. ":" .. (vim.env.PATH or "")
  end
end

require("config.lazy")
