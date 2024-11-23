local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

if wezterm.config_builder then config = wezterm.config_builder() end

-- Basic settings
config.color_scheme = "Dracula"
config.window_background_opacity = 1
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000

-- Make inactive panes dim
config.inactive_pane_hsb = {
  saturation = 0.24,
  brightness = 0.5
}

-- Leader key setup (Ctrl+a)
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

-- Key bindings
config.keys = {
  -- Pane management
  { key = "s", mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "v", mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "q", mods = "LEADER", action = act.CloseCurrentPane { confirm = true } },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "r", mods = "LEADER", action = act.ActivateKeyTable { name = "resize_pane", one_shot = false } },

  -- Tab management
  { key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "n", mods = "LEADER", action = act.ShowTabNavigator },
  { key = "m", mods = "LEADER", action = act.ActivateKeyTable { name = "move_tab", one_shot = false } },
}

-- Add number key bindings for tabs 1-9
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i - 1)
  })
end

-- Mode tables for resize and move
config.key_tables = {
  resize_pane = {
    { key = "h", action = act.AdjustPaneSize { "Left", 1 } },
    { key = "j", action = act.AdjustPaneSize { "Down", 1 } },
    { key = "k", action = act.AdjustPaneSize { "Up", 1 } },
    { key = "l", action = act.AdjustPaneSize { "Right", 1 } },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter", action = "PopKeyTable" },
  },
  move_tab = {
    { key = "h", action = act.MoveTabRelative(-1) },
    { key = "j", action = act.MoveTabRelative(-1) },
    { key = "k", action = act.MoveTabRelative(1) },
    { key = "l", action = act.MoveTabRelative(1) },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter", action = "PopKeyTable" },
  }
}

config.window_background_opacity = 1.0  -- Start with full opacity

local opacity_full = true  -- Track opacity state
wezterm.on("toggle-opacity", function(window, _)
  opacity_full = not opacity_full
  if opacity_full then
    window:set_config_overrides({ window_background_opacity = 1.0 })
  else
    window:set_config_overrides({ window_background_opacity = 0.9 })  -- Change 0.9 to your preferred transparency
  end
end)

-- Add this to your config.keys table
table.insert(config.keys, {
  key = "b",  -- You can change 'b' to any key you prefer
  mods = "LEADER",
  action = wezterm.action.EmitEvent("toggle-opacity"),
})


-- Enable workspace persistence
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false

-- Set default workspace
config.default_workspace = "main"

-- Add workspace switcher keybinding
table.insert(config.keys, {
  key = "w",
  mods = "LEADER",
  action = act.ShowLauncherArgs {
    flags = "FUZZY|WORKSPACES",
  },
})

-- Auto-save workspace on changes
wezterm.on("window-config-reloaded", function(window, pane)
  local workspace = window:get_workspace()
  window:perform_action(
    act.SaveWorkspace { name = workspace },
    pane
  )
end)

-- Save workspace when closing window
wezterm.on("window-close-requested", function(window, pane)
  local workspace = window:get_workspace()
  window:perform_action(
    act.SaveWorkspace { name = workspace },
    pane
  )
  -- Allow the close to proceed
  return false
end)


config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

return config
