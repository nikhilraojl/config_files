local function magiclines(s)
	-- iterator for strings as lines
	if s:sub(-1) ~= "\n" then s = s .. "\n" end
	return s:gmatch("(.-)\n")
end

local wezterm = require 'wezterm'
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- used to set accent color if on windows
local theme_color = 'orange'

-- windows specific configuration
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
	-- local success, stdout, _ = wezterm.run_child_process { 'cmd', '/c', 'reg.exe query hkey_current_user\\software\\microsoft\\windows\\dwm /f colorizationcolor /e' }

	-- if success then
	-- 	for line in magiclines(stdout) do
	-- 		local found = string.find(line, 'ColorizationColor')
	-- 		if found then
	-- 			local _, _, value = line:match("^%s%s%s%s(.*)%s%s%s%s(.*)%s%s%s%s(.*)$")
	-- 			theme_color = string.sub(value, 5)
	-- 		end
	-- 	end
	-- end

	config.default_prog = { 'pwsh' }
	-- Add a powershell dev domain which auto imports VS 2022 dev tools
	-- NOTE: This requires `VS_BUILDTOOLS_DIR` env to be set
	local exec_domains = {}
	local build_tools_dir = os.getenv('VS_BUILDTOOLS_DIR')
	table.insert(exec_domains, wezterm.exec_domain('Dev Powershell vs22', function(cmd)
		cmd.cwd = build_tools_dir
		local args = {
			'pwsh',
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
	scrollbar_thumb = theme_color,
	split = theme_color
}
config.audible_bell = "Disabled"
config.inactive_pane_hsb = {
	brightness = 0.5,
}

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
	{ key = 'PageUp',   mods = '',           action = act.ScrollByPage(-1) },
	{ key = 'u',        mods = 'ALT',        action = act.ScrollByPage(-1) },
	{ key = 'PageDown', mods = '',           action = act.ScrollByPage(1) },
	{ key = 'd',        mods = 'ALT',        action = act.ScrollByPage(1) },
	-- tab related keymaps
	{ key = 'Tab',      mods = 'CTRL',       action = act.ActivateTabRelative(1) },
	{ key = 'Tab',      mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(-1) },
	{
		key = 'T',
		mods = 'CTRL',
		action = act.SpawnCommandInNewTab {
			cwd = wezterm.home_dir
		}
	},
	{
		key = 'T',
		mods = 'SHIFT|CTRL',
		action = act.SpawnCommandInNewTab {
			cwd = wezterm.home_dir
		}
	},
	{ key = '1',  mods = 'ALT',        action = act.ActivateTab(0) },
	{ key = '2',  mods = 'ALT',        action = act.ActivateTab(1) },
	{ key = '3',  mods = 'ALT',        action = act.ActivateTab(2) },
	{ key = '4',  mods = 'ALT',        action = act.ActivateTab(3) },
	{ key = 'w',  mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = true } },
	-- Window related keymaps
	{ key = 'n',  mods = 'SHIFT|CTRL', action = act.SpawnWindow },
	{ key = 'N',  mods = 'SHIFT|CTRL', action = act.SpawnWindow },
	-- Pane handling keymaps
	{ key = '+',  mods = 'ALT|SHIFT',  action = act.SplitPane { direction = 'Right' } },
	{ key = '_',  mods = 'ALT|SHIFT',  action = act.SplitPane { direction = 'Down' } },
	{ key = 'h',  mods = 'ALT|SHIFT',  action = act.AdjustPaneSize { 'Left', 10 } },
	{ key = 'l',  mods = 'ALT|SHIFT',  action = act.AdjustPaneSize { 'Right', 10 } },
	{ key = 'j',  mods = 'ALT|SHIFT',  action = act.AdjustPaneSize { 'Down', 3 } },
	{ key = 'k',  mods = 'ALT|SHIFT',  action = act.AdjustPaneSize { 'Up', 3 } },
	{ key = 'h',  mods = 'ALT',        action = act.ActivatePaneDirection('Left') },
	{ key = 'l',  mods = 'ALT',        action = act.ActivatePaneDirection('Right') },
	{ key = 'j',  mods = 'ALT',        action = act.ActivatePaneDirection('Down') },
	{ key = 'k',  mods = 'ALT',        action = act.ActivatePaneDirection('Up') },
	{ key = '\\', mods = 'ALT',        action = act.TogglePaneZoomState },
	{ key = '>',  mods = 'ALT|SHIFT',  action = act.RotatePanes('Clockwise') },
	{ key = '<',  mods = 'ALT|SHIFT',  action = act.RotatePanes('CounterClockwise') },
	-- copy mode & search mode keymaps
	{ key = 'x',  mods = 'ALT',        action = act.ActivateCopyMode },
	{ key = 'x',  mods = 'SHIFT|ALT',  action = act.ActivateCopyMode },
	{ key = '/',  mods = 'ALT',        action = act.Search 'CurrentSelectionOrEmptyString' },
	-- launcher keymaps
	{ key = 'p',  mods = 'ALT',        action = wezterm.action.ShowLauncher },
	{ key = 'p',  mods = 'ALT|SHIFT',  action = wezterm.action.ShowLauncherArgs { flags = 'DOMAINS' } },
	{ key = 'P',  mods = 'ALT',        action = wezterm.action.ShowLauncherArgs { flags = 'DOMAINS' } },
}
return config
