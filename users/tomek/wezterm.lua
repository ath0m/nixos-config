---@diagnostic disable: unused-local
local wezterm = require('wezterm')
local act = wezterm.action
local font = 'Fira Code'
local key_mod_panes = 'CMD'

-- Global state
local state = {
  debug_mode = false,
}

local key_table_leader = { key = 'a', mods = 'CTRL' }

local keys = {
  {
    key = ',',
    mods = 'CMD',
    action = act.PromptInputLine({
      description = 'Launch',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            act.SpawnCommandInNewWindow({
              args = wezterm.shell_split(line),
            }),
            pane
          )
        end
      end),
    }),
  },

  {
    key = '>',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function()
      state.debug_mode = not state.debug_mode
    end),
  },

  { key = 'PageUp',   mods = 'SHIFT', action = act.ScrollByPage(-1) },
  { key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(1) },

  {
    key = '.',
    mods = 'CMD',
    action = wezterm.action.ActivateCommandPalette,
  },

  {
    key = 'Enter',
    mods = key_mod_panes,
    action = act.ToggleFullScreen,
  },

  {
    key = ':',
    mods = key_mod_panes,
    action = act.ShowDebugOverlay,
  },

  -- Panes
  {
    key = 'p',
    mods = 'LEADER',
    action = act.ActivateKeyTable({
      name = 'pane',
      timeout_milliseconds = 1500,
    }),
  },

  {
    key = 'd',
    mods = key_mod_panes,
    action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
  },

  {
    key = 'D',
    mods = 'SHIFT|' .. key_mod_panes,
    action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
  },

  {
    key = 'w',
    mods = key_mod_panes,
    action = act.CloseCurrentPane({ confirm = true }),
  },

  {
    key = 'z',
    mods = key_mod_panes,
    action = act.TogglePaneZoomState,
  },

  {
    key = '!',
    mods = 'SHIFT|' .. key_mod_panes,
    action = wezterm.action_callback(function(_win, pane)
      pane:move_to_new_window()
    end),
  },

  -- Activation
  {
    key = 'h',
    mods = key_mod_panes,
    action = act.ActivatePaneDirection('Left'),
  },

  {
    key = 'l',
    mods = key_mod_panes,
    action = act.ActivatePaneDirection('Right'),
  },

  {
    key = 'k',
    mods = key_mod_panes,
    action = act.ActivatePaneDirection('Up'),
  },

  {
    key = 'j',
    mods = key_mod_panes,
    action = act.ActivatePaneDirection('Down'),
  },

  -- Size
  {
    key = 'H',
    mods = 'SHIFT|' .. key_mod_panes,
    action = act.AdjustPaneSize({ 'Left', 1 }),
  },

  {
    key = 'J',
    mods = 'SHIFT|' .. key_mod_panes,
    action = act.AdjustPaneSize({ 'Down', 1 }),
  },

  {
    key = 'K',
    mods = 'SHIFT|' .. key_mod_panes,
    action = act.AdjustPaneSize({ 'Up', 1 }),
  },

  {
    key = 'L',
    mods = 'SHIFT|' .. key_mod_panes,
    action = act.AdjustPaneSize({ 'Right', 1 }),
  },

  -- Rotate
  {
    key = 'r',
    mods = key_mod_panes,
    action = act.RotatePanes('CounterClockwise'),
  },

  {
    key = 'R',
    mods = 'SHIFT|CMD',
    action = act.RotatePanes('Clockwise'),
  },

  -- Select and focus
  {
    key = 's',
    mods = key_mod_panes,
    action = act.PaneSelect,
  },

  -- Select and swap
  {
    key = 'S',
    mods = 'SHIFT|' .. key_mod_panes,
    action = act.PaneSelect({
      mode = 'SwapWithActive',
    }),
  },

  -- Tabs
  {
    key = 't',
    mods = 'CMD',
    action = act.SpawnCommandInNewTab({ cwd = wezterm.home_dir }),
  },

  { key = 'T', mods = 'SHIFT|' .. key_mod_panes,      action = act.ShowTabNavigator },
  { key = 'H', mods = 'SHIFT|' .. key_mod_panes,      action = act.ActivateTabRelative(-1) },
  { key = 'L', mods = 'SHIFT|' .. key_mod_panes,      action = act.ActivateTabRelative(1) },
  { key = 'H', mods = 'SHIFT|CTRL|' .. key_mod_panes, action = act.MoveTabRelative(-1) },
  { key = 'L', mods = 'SHIFT|CTRL|' .. key_mod_panes, action = act.MoveTabRelative(1) },

  {
    key = 'o',
    mods = key_mod_panes,
    action = act.ActivateLastTab,
  },

  -- Utils
  {
    key = '0',
    mods = key_mod_panes,
    action = act.ResetFontSize,
  },

  {
    key = 'x',
    mods = 'SHIFT|' .. key_mod_panes,
    action = act.ActivateCopyMode,
  },

  {
    key = 'L',
    mods = 'CTRL|SHIFT',
    action = act.QuickSelectArgs({
      patterns = {
        'https?://\\S+',
      },
    }),
  },

  -- Jump word to the left
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = act.SendKey({
      key = 'b',
      mods = 'ALT',
    }),
  },

  -- Jump word to the right
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = act.SendKey({ key = 'f', mods = 'ALT' }),
  },

  -- Go to beginning of line
  {
    key = 'LeftArrow',
    mods = 'CMD',
    action = act.SendKey({
      key = 'a',
      mods = 'CTRL',
    }),
  },

  -- Go to end of line
  {
    key = 'RightArrow',
    mods = 'CMD',
    action = act.SendKey({ key = 'e', mods = 'CTRL' }),
  },

  -- Bypass
  { key = '/', mods = 'CTRL', action = act.SendKey({ key = '/', mods = 'CTRL' }) },
  { key = 'q', mods = 'CTRL', action = act.SendKey({ key = 'q', mods = 'CTRL' }) },
  { key = 'k', mods = 'CTRL', action = act.SendKey({ key = 'k', mods = 'CTRL' }) },
  { key = 'i', mods = 'CTRL', action = act.SendKey({ key = 'i', mods = 'CTRL' }) },

  -- Workspace
  {
    key = 'y',
    mods = 'SHIFT|' .. key_mod_panes,
    action = act.SwitchToWorkspace {
      name = 'default',
    },
  },

  -- Create a new workspace with a random name and switch to it
  { key = 'i', mods = 'CTRL|SHIFT', action = act.SwitchToWorkspace },

  -- Show the launcher in fuzzy selection mode and have it list all workspaces
  -- and allow activating one.
  {
    key = '9',
    mods = 'ALT',
    action = act.ShowLauncherArgs {
      flags = 'FUZZY|WORKSPACES',
    },
  },

  -- Prompt for a name to use for a new workspace and switch to it.
  {
    key = 'W',
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Enter name for new workspace' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:perform_action(
            act.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end),
    },
  },
}

local key_tables = {
  pane = {
    {
      key = 't',
      action = wezterm.action_callback(function(_win, pane)
        pane:move_to_new_tab()
      end),
    },

    -- vertical slim panel
    {
      key = 'v',
      action = act.SplitPane({
        direction = 'Right',
        size = { Percent = 35 },
      }),
    },

    {
      key = 'h',
      action = act.SplitPane({
        direction = 'Down',
        size = { Percent = 35 },
      }),
    },
  },
}

local process_icons = {
  ['docker'] = wezterm.nerdfonts.linux_docker,
  ['psql'] = '󱤢',
  ['usql'] = '󱤢',
  ['ssh'] = wezterm.nerdfonts.fa_exchange,
  ['ssh-add'] = wezterm.nerdfonts.fa_exchange,
  ['kubectl'] = wezterm.nerdfonts.linux_docker,
  ['stern'] = wezterm.nerdfonts.linux_docker,
  ['nvim'] = wezterm.nerdfonts.custom_vim,
  ['make'] = wezterm.nerdfonts.seti_makefile,
  ['node'] = wezterm.nerdfonts.mdi_hexagon,
  ['go'] = wezterm.nerdfonts.seti_go,
  ['python3'] = '',
  ['fish'] = wezterm.nerdfonts.dev_terminal,
  ['htop'] = wezterm.nerdfonts.mdi_chart_donut_variant,
  ['cargo'] = wezterm.nerdfonts.dev_rust,
  ['sudo'] = wezterm.nerdfonts.fa_hashtag,
  ['git'] = wezterm.nerdfonts.dev_git,
  ['lua'] = wezterm.nerdfonts.seti_lua,
  ['wget'] = wezterm.nerdfonts.mdi_arrow_down_box,
  ['curl'] = wezterm.nerdfonts.mdi_flattr,
  ['gh'] = wezterm.nerdfonts.dev_github_badge,
  ['ruby'] = wezterm.nerdfonts.cod_ruby,
}

local function get_current_working_dir(tab)
  local current_dir = tab.active_pane and tab.active_pane.current_working_dir or { file_path = '' }
  local HOME_DIR = os.getenv('HOME')

  return current_dir.file_path == HOME_DIR and '~'
      or string.gsub(current_dir.file_path, '(.*[/\\])(.*)', '%2')
end

local function get_process(tab)
  if not tab.active_pane or tab.active_pane.foreground_process_name == '' then
    return nil
  end

  local process_name = string.gsub(tab.active_pane.foreground_process_name, '(.*[/\\])(.*)', '%2')
  if string.find(process_name, 'kubectl') then
    process_name = 'kubectl'
  end

  return process_icons[process_name] or string.format('[%s]', process_name)
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local has_unseen_output = false
  if not tab.is_active then
    for _, pane in ipairs(tab.panes) do
      if pane.has_unseen_output then
        has_unseen_output = true
        break
      end
    end
  end

  local cwd = wezterm.format({
    { Text = get_current_working_dir(tab) },
  })

  local process = get_process(tab)
  local title = process and string.format(' %s (%s)  ', process, cwd) or ' [?] '

  if has_unseen_output then
    return {
      { Foreground = { Color = '#28719c' } },
      { Text = title },
    }
  end

  return {
    { Text = title },
  }
end)

wezterm.on('update-status', function(window, pane)
  local process = ''

  if state.debug_mode then
    local info = pane:get_foreground_process_info()
    if info then
      process = info.name
      for i = 2, #info.argv do
        process = info.argv[i]
      end
    end
  end

  local status = (#process > 0 and ' | ' or '')
  local name = window:active_key_table()
  if name then
    status = string.format('󰌌  {%s}', name)
  end

  if window:get_dimensions().is_full_screen then
    status = status .. wezterm.strftime(' %R ')
  end

  window:set_right_status(wezterm.format({
    { Foreground = { Color = '#7eb282' } },
    { Text = process },
    { Foreground = { Color = '#808080' } },
    { Text = status },
  }))

  -- Workspace name
  local stat = window:active_workspace()
  local stat_color = "#f7768e"
  -- It's a little silly to have workspace name all the time
  -- Utilize this to display LDR or current key table name
  if window:active_key_table() then
    stat = window:active_key_table()
    stat_color = "#7dcfff"
  end
  if window:leader_is_active() then
    stat = "LDR"
    stat_color = "#bb9af7"
  end

  window:set_left_status(wezterm.format({
    { Foreground = { Color = stat_color } },
    { Text = "  " },
    { Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
    { Text = " |" },
  }))
end)

local config = {
  adjust_window_size_when_changing_font_size = false,
  audible_bell = 'Disabled',
  canonicalize_pasted_newlines = 'None',
  color_scheme = 'Catppuccin Mocha',
  cursor_blink_rate = 500,
  default_cursor_style = 'BlinkingBlock',
  default_cwd = wezterm.home_dir,
  font = wezterm.font(font, { weight = 'Regular' }),
  font_size = 13.0,
  hyperlink_rules = wezterm.default_hyperlink_rules(),
  inactive_pane_hsb = {
    saturation = 1.0,
    brightness = 0.6,
  },
  keys = keys,
  key_tables = key_tables,
  leader = key_table_leader,
  max_fps = 120,
  -- mouse_bindings = {
  --   {
  --     event = { Up = { streak = 1, button = 'Left' } },
  --     mods = 'NONE',
  --     action = act.CompleteSelection('PrimarySelection'),
  --   },
  --
  --   {
  --     event = { Up = { streak = 1, button = 'Left' } },
  --     mods = 'CMD',
  --     action = act.OpenLinkAtMouseCursor,
  --   },
  -- },
  scrollback_lines = 3000,
  send_composed_key_when_left_alt_is_pressed = false,
  show_new_tab_button_in_tab_bar = false,
  switch_to_last_active_tab_when_closing_tab = true,
  tab_max_width = 80,
  underline_position = -4,
  use_fancy_tab_bar = false,
  window_background_opacity = 1,
  macos_window_background_blur = 19,
  window_decorations = 'RESIZE',
  tab_bar_at_bottom = true,
}

return config
