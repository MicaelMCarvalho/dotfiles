return {
  {
    "m4xshen/autoclose.nvim",
    lazy = false,
    opts = {
      disabled_filetypes = { "text", "command" },
      disable_when_touch = false,
      disable_command_mode = true,
    },
    keys = {
      ["("] = { escape = false, close = true, pair = "()"},
      ["["] = { escape = false, close = true, pair = "[]"},
      ["{"] = { escape = false, close = true, pair = "{}"},

      [">"] = { escape = true, close = false, pair = "<>"},
      [")"] = { escape = true, close = false, pair = "()"},
      ["]"] = { escape = true, close = false, pair = "[]"},
      ["}"] = { escape = true, close = false, pair = "{}"},

      ['"'] = { escape = true, close = true, pair = '""'},
      ["'"] = { escape = true, close = true, pair = "''"},
      ["`"] = { escape = true, close = true, pair = "``"},
    },
  }
}
