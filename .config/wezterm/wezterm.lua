local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- basics
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.hide_mouse_cursor_when_typing = false
config.default_cursor_style = 'SteadyBar'

-- color
config.color_scheme = 'Catppuccin Mocha'

-- font
config.font = wezterm.font_with_fallback {'JetBrainsMono', 'Font Awesome 6 Free', 'Noto Serif'}
config.font_size = 11

config.keys = {
  {
    key = 'r',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ReloadConfiguration,
  },

  -- This is required in the wezterm config for the tmux config described here to work: https://unix.stackexchange.com/a/96936
  { key = "0", mods = "CTRL", action = act.SendString '\x1b[27;5;48~' },
  { key = "1", mods = "CTRL", action = act.SendString '\x1b[27;5;49~' },
  { key = "2", mods = "CTRL", action = act.SendString '\x1b[27;5;50~' },
  { key = "3", mods = "CTRL", action = act.SendString '\x1b[27;5;51~' },
  { key = "4", mods = "CTRL", action = act.SendString '\x1b[27;5;52~' },
  { key = "5", mods = "CTRL", action = act.SendString '\x1b[27;5;53~' },
  { key = "6", mods = "CTRL", action = act.SendString '\x1b[27;5;54~' },
  { key = "7", mods = "CTRL", action = act.SendString '\x1b[27;5;55~' },
  { key = "8", mods = "CTRL", action = act.SendString '\x1b[27;5;56~' },
  { key = "9", mods = "CTRL", action = act.SendString '\x1b[27;5;57~' },
}

config.mouse_bindings = {
  -- Change the default click behavior so that it only selects text and doesn't open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
  },

  -- Make Ctrl-Click open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
    mouse_reporting = true --- this fixes it from not working in tmux
  },

  -- Fix shift+selection: https://github.com/wez/wezterm/issues/2910#issuecomment-1441182554
  { event = { Down = { streak = 1, button = 'Left' } }, mods = 'SHIFT', action = act.SelectTextAtMouseCursor('Cell'), },
  { event = { Down = { streak = 1, button = 'Middle' } }, mods = 'SHIFT', action = act.PasteFrom('PrimarySelection'), },
  { event = { Down = { streak = 2, button = 'Left' } }, mods = 'SHIFT', action = act.SelectTextAtMouseCursor('Word'), },
  { event = { Down = { streak = 3, button = 'Left' } }, mods = 'SHIFT', action = act.SelectTextAtMouseCursor('Line'), },
  { event = { Drag = { streak = 1, button = 'Left' } }, mods = 'SHIFT', action = act.ExtendSelectionToMouseCursor('Cell'), },
  { event = { Drag = { streak = 2, button = 'Left' } }, mods = 'SHIFT', action = act.ExtendSelectionToMouseCursor('Word'), },
  { event = { Drag = { streak = 3, button = 'Left' } }, mods = 'SHIFT', action = act.ExtendSelectionToMouseCursor('Line'), },
  { event = { Up = { streak = 2, button = 'Left' } }, mods = 'SHIFT', action = act.CompleteSelection('ClipboardAndPrimarySelection'), },
  { event = { Up = { streak = 3, button = 'Left' } }, mods = 'SHIFT', action = act.CompleteSelection('ClipboardAndPrimarySelection'), },
}


return config
