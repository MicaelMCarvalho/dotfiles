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

local wezterm = require("wezterm")
local act = wezterm.action

-- Create a mapping of action IDs to their actual actions
local action_map = {
  ["split-vertical"] = act.SplitVertical { domain = "CurrentPaneDomain" },
  ["split-horizontal"] = act.SplitHorizontal { domain = "CurrentPaneDomain" },
  ["move-left"] = act.ActivatePaneDirection("Left"),
  ["move-down"] = act.ActivatePaneDirection("Down"),
  ["move-up"] = act.ActivatePaneDirection("Up"),
  ["move-right"] = act.ActivatePaneDirection("Right"),
  ["close-pane"] = act.CloseCurrentPane { confirm = true },
  ["toggle-zoom"] = act.TogglePaneZoomState,
  ["resize-mode"] = act.ActivateKeyTable { name = "resize_pane", one_shot = false },
  ["new-tab"] = act.SpawnTab("CurrentPaneDomain"),
  ["prev-tab"] = act.ActivateTabRelative(-1),
  ["next-tab"] = act.ActivateTabRelative(1),
  ["show-tab-nav"] = act.ShowTabNavigator,
  ["move-tab-mode"] = act.ActivateKeyTable { name = "move_tab", one_shot = false },
  ["workspace-switcher"] = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" },
  ["toggle-opacity"] = wezterm.action.EmitEvent("toggle-opacity"),
}

-- Function to generate keymap descriptions with action IDs
local function get_keymap_descriptions()
  return {
    { label = "Split pane vertically (LEADER + s)", id = "split-vertical" },
    { label = "Split pane horizontally (LEADER + v)", id = "split-horizontal" },
    { label = "Navigate to left pane (LEADER + h)", id = "move-left" },
    { label = "Navigate to pane below (LEADER + j)", id = "move-down" },
    { label = "Navigate to pane above (LEADER + k)", id = "move-up" },
    { label = "Navigate to right pane (LEADER + l)", id = "move-right" },
    { label = "Close current pane (LEADER + q)", id = "close-pane" },
    { label = "Toggle pane zoom (LEADER + z)", id = "toggle-zoom" },
    { label = "Enter resize mode (LEADER + r)", id = "resize-mode" },
    { label = "Create new tab (LEADER + t)", id = "new-tab" },
    { label = "Previous tab (LEADER + [)", id = "prev-tab" },
    { label = "Next tab (LEADER + ])", id = "next-tab" },
    { label = "Show tab navigator (LEADER + n)", id = "show-tab-nav" },
    { label = "Enter move tab mode (LEADER + m)", id = "move-tab-mode" },
    { label = "Show workspace switcher (LEADER + w)", id = "workspace-switcher" },
    { label = "Toggle opacity (LEADER + b)", id = "toggle-opacity" },
  }
end

-- Add this to your key bindings
table.insert(config.keys, {
  key = "?",
  mods = "LEADER",
  action = act.InputSelector {
    title = "Keybindings",
    choices = get_keymap_descriptions(),
    fuzzy = true,
    action = wezterm.action_callback(function(window, pane, id, label)
      if action_map[id] then
        window:perform_action(action_map[id], pane)
      end
    end),
  },
})

config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

return config
