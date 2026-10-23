return {
    {
    'folke/todo-comments.nvim',
    dependencies = "nvim-lua/plenary.nvim",
    opts  = {
      signs = true, -- show icons in the signs column
      keywords = {
        TODO = { icon = " ", color = "info" },
        FIX = { icon = " ", color = "error" },
        NOTE = { icon = " ", color = "hint" },
      },
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarning", "WarningMsg", "#FBBF24" },
        info = { "DiagnosticInfo", "#2563EB" },
        hint = { "DiagnosticHint", "#10B981" },
      },
    }
  }
}
