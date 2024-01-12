local wezterm = require 'wezterm'
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- windows specific changes
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
	config.default_prog = { 'pwsh' }
	-- Add domain for auto importing VS 2022 dev tools
	-- NOTE: This requires `VS_BUILDTOOLS_DIR` env to be set
	local exec_domains = {}
	local build_tools_dir = os.getenv('VS_BUILDTOOLS_DIR')
	table.insert(exec_domains, wezterm.exec_domain('Dev Powershell vs22', function(cmd)
		cmd.cwd = build_tools_dir
		local args = {
			'powershell.exe',
			'-NoExit',
			'-Command',
			'.\\Launch-VsDevShell.ps1'
			-- use below if `Launch-VsDevShell.ps1` doesn't work
			-- '&{Import-Module <build_tools_dir>; Enter-VsDevShell <hash> -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"};',
		}

		cmd.args = args
		return cmd
	end))
	config.exec_domains = exec_domains
end

-- UI customizations
config.font = wezterm.font_with_fallback {
	'Cascadia Mono'
}
config.color_scheme = 'Batman'
config.enable_scroll_bar = true
config.colors = {
	scrollbar_thumb = 'orange',
	split = "orange"
}
config.audible_bell = "Disabled"

-- Keyboard bindings
local act = wezterm.action
config.disable_default_key_bindings = true
config.keys = {
	-- clipboard related keymaps
	{ key = 'C',        mods = 'CTRL',       action = act.CopyTo 'ClipboardAndPrimarySelection' },
	{ key = 'C',        mods = 'SHIFT|CTRL', action = act.CopyTo 'ClipboardAndPrimarySelection' },
	{ key = 'V',        mods = 'CTRL',       action = act.PasteFrom 'Clipboard' },
	{ key = 'V',        mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
	-- increase and decrease font size
	{ key = '=',        mods = 'CTRL',       action = act.IncreaseFontSize },
	{ key = '+',        mods = 'SHIFT|CTRL', action = act.IncreaseFontSize },
	{ key = '-',        mods = 'CTRL',       action = act.DecreaseFontSize },
	{ key = '_',        mods = 'SHIFT|CTRL', action = act.DecreaseFontSize },
	{ key = '0',        mods = 'CTRL',       action = act.ResetFontSize },
	-- scroll related keymaps
	{ key = 'PageUp',   mods = 'SHIFT',      action = act.ScrollByPage(-1) },
	{ key = 'u',        mods = 'ALT',        action = act.ScrollByPage(-1) },
	{ key = 'PageDown', mods = 'SHIFT',      action = act.ScrollByPage(1) },
	{ key = 'd',        mods = 'ALT',        action = act.ScrollByPage(1) },
	-- tab related keymaps
	{ key = 'Tab',      mods = 'CTRL',       action = act.ActivateTabRelative(1) },
	{ key = 'Tab',      mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(-1) },
	{ key = 'T',        mods = 'CTRL',       action = act.SpawnTab 'CurrentPaneDomain' },
	{ key = 'T',        mods = 'SHIFT|CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
	{ key = '1',        mods = 'ALT',        action = act.ActivateTab(0) },
	{ key = '2',        mods = 'ALT',        action = act.ActivateTab(1) },
	{ key = '3',        mods = 'ALT',        action = act.ActivateTab(2) },
	{ key = '4',        mods = 'ALT',        action = act.ActivateTab(3) },
	{ key = 'w',        mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = true } },
	-- Window related keymaps
	{ key = 'n',        mods = 'SHIFT|CTRL', action = act.SpawnWindow },
	{ key = 'N',        mods = 'SHIFT|CTRL', action = act.SpawnWindow },
	-- Pane handling keymaps
	{ key = '+',        mods = 'ALT|SHIFT',  action = act.SplitPane { direction = 'Right' } },
	{ key = '_',        mods = 'ALT|SHIFT',  action = act.SplitPane { direction = 'Down' } },
	{ key = 'h',        mods = 'ALT|SHIFT',  action = act.AdjustPaneSize { 'Left', 10 } },
	{ key = 'l',        mods = 'ALT|SHIFT',  action = act.AdjustPaneSize { 'Right', 10 } },
	{ key = 'j',        mods = 'ALT|SHIFT',  action = act.AdjustPaneSize { 'Down', 3 } },
	{ key = 'k',        mods = 'ALT|SHIFT',  action = act.AdjustPaneSize { 'Up', 3 } },
	{ key = 'h',        mods = 'ALT',        action = act.ActivatePaneDirection('Left') },
	{ key = 'l',        mods = 'ALT',        action = act.ActivatePaneDirection('Right') },
	{ key = 'j',        mods = 'ALT',        action = act.ActivatePaneDirection('Down') },
	{ key = 'k',        mods = 'ALT',        action = act.ActivatePaneDirection('Up') },
	{ key = '\\',       mods = 'ALT',        action = act.TogglePaneZoomState },
	{ key = '>',        mods = 'ALT|SHIFT',  action = act.RotatePanes('Clockwise') },
	{ key = '<',        mods = 'ALT|SHIFT',  action = act.RotatePanes('CounterClockwise') },
	-- setup copy mode for copying and searching text
	{ key = 'X',        mods = 'ALT',        action = act.ActivateCopyMode },
	{ key = 'X',        mods = 'SHIFT|ALT',  action = act.ActivateCopyMode },
	-- launcher keymaps
	{ key = 'p',        mods = 'ALT',        action = wezterm.action.ShowLauncher },
	{ key = 'p',        mods = 'ALT|SHIFT',  action = wezterm.action.ShowLauncherArgs { flags = 'DOMAINS' } },
	{ key = 'P',        mods = 'ALT',        action = wezterm.action.ShowLauncherArgs { flags = 'DOMAINS' } },
}
return config
