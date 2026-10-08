local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- ============================================================
-- APPEARANCE
-- ============================================================

config.color_scheme = "Dracula"

config.window_background_opacity = 1.0
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"

config.scrollback_lines = 3000

-- Dim inactive panes
config.inactive_pane_hsb = {
  saturation = 0.24,
  brightness = 0.5,
}

-- Tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false


-- ============================================================
-- MACOS KEYBOARD BEHAVIOR
-- ============================================================

config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true


-- ============================================================
-- LEADER KEY
-- Ctrl+A
-- ============================================================

config.leader = {
  key = "a",
  mods = "CTRL",
  timeout_milliseconds = 1000,
}


config.default_cwd = wezterm.home_dir

-- ============================================================
-- HELPER FUNCTIONS
-- ============================================================

-- Create a new tab immediately after the currently active tab
local function spawn_tab_after_current(window, pane)
  local mux_window = window:mux_window()
  local current_tab = mux_window:active_tab()

  -- Get the current tab index (zero-based)
  local current_index = 0

  for i, tab in ipairs(mux_window:tabs()) do
    if tab:tab_id() == current_tab:tab_id() then
      current_index = i - 1
      break
    end
  end

  -- Create a new tab, inheriting the current directory
  window:perform_action(
    act.SpawnTab("CurrentPaneDomain"),
    pane
  )

  -- Move the new active tab to the desired position
  wezterm.time.call_after(0.2, function()
    window:perform_action(
      act.MoveTab(current_index + 1),
      mux_window:active_tab():active_pane()
    )
  end)
end

local new_tab_action = wezterm.action_callback(spawn_tab_after_current)


-- ============================================================
-- TRANSPARENCY TOGGLE
-- Leader + B
-- ============================================================

local opacity_full = true

wezterm.on("toggle-opacity", function(window, pane)
  opacity_full = not opacity_full

  if opacity_full then
    window:set_config_overrides({
      window_background_opacity = 1.0,
    })
  else
    window:set_config_overrides({
      window_background_opacity = 0.9,
    })
  end
end)


-- ============================================================
-- WORKSPACES
-- ============================================================

config.default_workspace = "main"

-- Save workspace when configuration reloads
wezterm.on("window-config-reloaded", function(window, pane)
  local workspace = window:get_workspace()

  window:perform_action(
    act.SaveWorkspace {
      name = workspace,
    },
    pane
  )
end)

-- Save workspace when closing window
wezterm.on("window-close-requested", function(window, pane)
  local workspace = window:get_workspace()

  window:perform_action(
    act.SaveWorkspace {
      name = workspace,
    },
    pane
  )

  return false
end)


-- ============================================================
-- KEYBINDINGS
-- ============================================================

config.keys = {

  -- ----------------------------------------------------------
  -- MACOS-STYLE COMMAND LINE NAVIGATION
  -- ----------------------------------------------------------

  -- Option + Left: Previous word
  {
    key = "LeftArrow",
    mods = "OPT",
    action = act.SendKey {
      key = "b",
      mods = "ALT",
    },
  },

  -- Option + Right: Next word
  {
    key = "RightArrow",
    mods = "OPT",
    action = act.SendKey {
      key = "f",
      mods = "ALT",
    },
  },

  -- Cmd + Left: Beginning of line
  {
    key = "LeftArrow",
    mods = "CMD",
    action = act.SendKey {
      key = "a",
      mods = "CTRL",
    },
  },

  -- Cmd + Right: End of line
  {
    key = "RightArrow",
    mods = "CMD",
    action = act.SendKey {
      key = "e",
      mods = "CTRL",
    },
  },

  -- Option + Backspace: Delete previous word
  {
    key = "Backspace",
    mods = "OPT",
    action = act.SendKey {
      key = "w",
      mods = "CTRL",
    },
  },

  -- Cmd + Backspace: Delete to beginning of line
  {
    key = "Backspace",
    mods = "CMD",
    action = act.SendKey {
      key = "u",
      mods = "CTRL",
    },
  },


  -- ----------------------------------------------------------
  -- PANE MANAGEMENT
  -- ----------------------------------------------------------

  -- Split top/bottom
  {
    key = "s",
    mods = "LEADER",
    action = act.SplitVertical {
      domain = "CurrentPaneDomain",
    },
  },

  -- Split left/right
  {
    key = "v",
    mods = "LEADER",
    action = act.SplitHorizontal {
      domain = "CurrentPaneDomain",
    },
  },

  -- Navigate panes
  {
    key = "h",
    mods = "LEADER",
    action = act.ActivatePaneDirection("Left"),
  },

  {
    key = "j",
    mods = "LEADER",
    action = act.ActivatePaneDirection("Down"),
  },

  {
    key = "k",
    mods = "LEADER",
    action = act.ActivatePaneDirection("Up"),
  },

  {
    key = "l",
    mods = "LEADER",
    action = act.ActivatePaneDirection("Right"),
  },

  -- Close pane
  {
    key = "q",
    mods = "LEADER",
    action = act.CloseCurrentPane {
      confirm = true,
    },
  },

  -- Zoom/unzoom pane
  {
    key = "z",
    mods = "LEADER",
    action = act.TogglePaneZoomState,
  },

  -- Resize mode
  {
    key = "r",
    mods = "LEADER",
    action = act.ActivateKeyTable {
      name = "resize_pane",
      one_shot = false,
    },
  },


  -- ----------------------------------------------------------
  -- TAB MANAGEMENT
  -- ----------------------------------------------------------

  -- New tab immediately after current tab
  {
    key = "t",
    mods = "LEADER",
    action = new_tab_action,
  },

  -- Previous tab
  {
    key = "[",
    mods = "LEADER",
    action = act.ActivateTabRelative(-1),
  },

  -- Next tab
  {
    key = "]",
    mods = "LEADER",
    action = act.ActivateTabRelative(1),
  },

  -- Tab navigator
  {
    key = "n",
    mods = "LEADER",
    action = act.ShowTabNavigator,
  },

  -- Move tab mode
  {
    key = "m",
    mods = "LEADER",
    action = act.ActivateKeyTable {
      name = "move_tab",
      one_shot = false,
    },
  },


  -- ----------------------------------------------------------
  -- WORKSPACE SWITCHER
  -- ----------------------------------------------------------

  {
    key = "w",
    mods = "LEADER",
    action = act.ShowLauncherArgs {
      flags = "FUZZY|WORKSPACES",
    },
  },


  -- ----------------------------------------------------------
  -- TRANSPARENCY
  -- ----------------------------------------------------------

  {
    key = "b",
    mods = "LEADER",
    action = act.EmitEvent("toggle-opacity"),
  },

}


-- ============================================================
-- TAB NUMBER SHORTCUTS
-- Leader + 1 through 9
-- ============================================================

for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i - 1),
  })
end


-- ============================================================
-- KEY TABLES
-- ============================================================

config.key_tables = {

  -- ----------------------------------------------------------
  -- RESIZE MODE
  -- Leader + R, then H/J/K/L
  -- Escape or Enter to exit
  -- ----------------------------------------------------------

  resize_pane = {
    {
      key = "h",
      action = act.AdjustPaneSize { "Left", 1 },
    },
    {
      key = "j",
      action = act.AdjustPaneSize { "Down", 1 },
    },
    {
      key = "k",
      action = act.AdjustPaneSize { "Up", 1 },
    },
    {
      key = "l",
      action = act.AdjustPaneSize { "Right", 1 },
    },
    {
      key = "Escape",
      action = "PopKeyTable",
    },
    {
      key = "Enter",
      action = "PopKeyTable",
    },
  },


  -- ----------------------------------------------------------
  -- MOVE TAB MODE
  -- Leader + M, then H/J/K/L
  -- Escape or Enter to exit
  -- ----------------------------------------------------------

  move_tab = {
    {
      key = "h",
      action = act.MoveTabRelative(-1),
    },
    {
      key = "j",
      action = act.MoveTabRelative(-1),
    },
    {
      key = "k",
      action = act.MoveTabRelative(1),
    },
    {
      key = "l",
      action = act.MoveTabRelative(1),
    },
    {
      key = "Escape",
      action = "PopKeyTable",
    },
    {
      key = "Enter",
      action = "PopKeyTable",
    },
  },

}


-- ============================================================
-- KEYBINDING ACTION MAP
-- Used by fuzzy keybinding menu
-- ============================================================

local action_map = {

  ["split-vertical"] = act.SplitVertical {
    domain = "CurrentPaneDomain",
  },

  ["split-horizontal"] = act.SplitHorizontal {
    domain = "CurrentPaneDomain",
  },

  ["move-left"] = act.ActivatePaneDirection("Left"),
  ["move-down"] = act.ActivatePaneDirection("Down"),
  ["move-up"] = act.ActivatePaneDirection("Up"),
  ["move-right"] = act.ActivatePaneDirection("Right"),

  ["close-pane"] = act.CloseCurrentPane {
    confirm = true,
  },

  ["toggle-zoom"] = act.TogglePaneZoomState,

  ["resize-mode"] = act.ActivateKeyTable {
    name = "resize_pane",
    one_shot = false,
  },

  ["new-tab"] = new_tab_action,

  ["prev-tab"] = act.ActivateTabRelative(-1),
  ["next-tab"] = act.ActivateTabRelative(1),

  ["show-tab-nav"] = act.ShowTabNavigator,

  ["move-tab-mode"] = act.ActivateKeyTable {
    name = "move_tab",
    one_shot = false,
  },

  ["workspace-switcher"] = act.ShowLauncherArgs {
    flags = "FUZZY|WORKSPACES",
  },

  ["toggle-opacity"] = act.EmitEvent("toggle-opacity"),

}


-- ============================================================
-- FUZZY KEYBINDING MENU
-- Leader + ?
-- ============================================================

local function get_keymap_descriptions()
  return {

    { label = "Split pane top/bottom (LEADER + s)", id = "split-vertical" },
    { label = "Split pane left/right (LEADER + v)", id = "split-horizontal" },

    { label = "Navigate left pane (LEADER + h)", id = "move-left" },
    { label = "Navigate down pane (LEADER + j)", id = "move-down" },
    { label = "Navigate up pane (LEADER + k)", id = "move-up" },
    { label = "Navigate right pane (LEADER + l)", id = "move-right" },

    { label = "Close pane (LEADER + q)", id = "close-pane" },
    { label = "Toggle pane zoom (LEADER + z)", id = "toggle-zoom" },
    { label = "Resize mode (LEADER + r)", id = "resize-mode" },

    { label = "New tab after current (LEADER + t)", id = "new-tab" },
    { label = "Previous tab (LEADER + [)", id = "prev-tab" },
    { label = "Next tab (LEADER + ])", id = "next-tab" },

    { label = "Tab navigator (LEADER + n)", id = "show-tab-nav" },
    { label = "Move tab mode (LEADER + m)", id = "move-tab-mode" },

    { label = "Workspace switcher (LEADER + w)", id = "workspace-switcher" },

    { label = "Toggle opacity (LEADER + b)", id = "toggle-opacity" },

  }
end


table.insert(config.keys, {
  key = "?",
  mods = "LEADER",

  action = act.InputSelector {
    title = "Keybindings",
    choices = get_keymap_descriptions(),
    fuzzy = true,

    action = wezterm.action_callback(function(window, pane, id, label)
      if id and action_map[id] then
        window:perform_action(action_map[id], pane)
      end
    end),
  },
})


-- ============================================================
-- RETURN CONFIG
-- ============================================================

return config
