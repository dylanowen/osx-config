local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

config.initial_cols = 160
config.initial_rows = 48

config.color_scheme = 'Afterglow (Gogh)'
config.font = wezterm.font 'Fira Code'
config.font_size = 13.5

-- start in the code folder
config.default_cwd = wezterm.home_dir .. '/code'

config.keys = {
  -- Clears the scrollback and viewport leaving the prompt line the new first line.
  {
    key = 'k',
    mods = 'CMD',
    action = act.ClearScrollback 'ScrollbackAndViewport',
  },
}


return config
