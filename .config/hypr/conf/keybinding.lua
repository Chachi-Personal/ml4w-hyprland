-- Configuration
local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Helper functions
local bind = hl.bind
local mod = function(key)
	return mainMod .. " + " .. key
end
local modShift = function(key)
	return "SUPER + SHIFT + " .. key
end
local modAlt = function(key)
	return "SUPER + ALT + " .. key
end
local modControl = function(key)
	return "SUPER + CTRL + " .. key
end
local altShift = function(key)
	return "ALT + SHIFT + " .. key
end
local alt = function(key)
	return "ALT + " .. key
end

local exec = function(cmd)
	return hl.dsp.exec_cmd(cmd)
end
local HYPRSCRIPTS = "~/.config/hypr/scripts"

-- Applications
local TERMINAL = "kitty"
local BROWSER = "helium-browser"
local TOR_BROWSER = "brave --tor"
local LAUNCHER = "~/.config/hypr/scripts/launcher.sh"
local CALC = "~/.config/ml4w/settings/calculator.sh"

-- Applications
bind(mod("RETURN"), exec(TERMINAL), { description = "Open terminal" })
bind(mod("KP_ENTER"), exec(TERMINAL), { description = "Open terminal" })
bind(mod("EQUAL"), exec(CALC), { description = "Open calculator" })
bind(mod("W"), exec(BROWSER), { description = "Open browser" })
bind(mod("E"), exec(TERMINAL .. " -e yazi"), { description = "Open filemanager" })
bind(mod("D"), exec(LAUNCHER), { description = "Open application launcher" })
bind(modShift("W"), exec(BROWSER .. " --incognito"), { description = "Open browser in incognito mode" })
bind(modShift("D"), exec(CALC), { description = "Open calculator" })
bind(modShift("RETURN"), exec(TERMINAL .. " -e yazi"), { description = "Open filemanager" })
bind(modShift("KP_ENTER"), exec(TERMINAL .. " -e yazi"), { description = "Open filemanager" })
bind(altShift("W"), exec(TOR_BROWSER), { description = "Open browser in tor mode" })
--
-- # Display
-- bind = $mainMod SHIFT, mouse_down, exec, hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') + 0.5}") # Increase display zoom
-- bind = $mainMod SHIFT, mouse_up, exec, hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') - 0.5}") # Decrease display zoom
-- bind = $mainMod SHIFT, Z, exec, hyprctl keyword cursor:zoom_factor 1 # Reset display zoom
--
-- # Windows
bind(mod("Q"), hl.dsp.window.close(), { description = "Quit window" })

bind(modShift("Q"), function()
	local w = hl.get_active_window()
	if w ~= nil then
		os.execute("kill " .. w.pid)
	end
end, { description = "Quit active window and all open instances" })
bind(
	mod("F"),
	hl.dsp.window.fullscreen({ mode = "fullscreen" }),
	{ description = "Toggle active window to fullscreen" }
)
bind(mod("M"), hl.dsp.layout("colresize +conf"), { description = "Toggle active window to maximized (scrolling)" })
-- 	-- hl.dsp.window.fullscreen_state({ internal = 0, client = 1, action = "toggle" }),
-- 	{ description = "Toggle active window to maximized" }
-- )

bind(mod("T"), hl.dsp.window.float(), { description = "Toggle active window floating" })
bind(mod("H"), hl.dsp.focus({ direction = "l" }), { description = "Focus left window" })
bind(mod("J"), hl.dsp.focus({ direction = "d" }), { description = "Focus down window" })
bind(mod("K"), hl.dsp.focus({ direction = "u" }), { description = "Focus up window" })
bind(mod("L"), hl.dsp.focus({ direction = "r" }), { description = "Focus right window" })
bind(modShift("H"), hl.dsp.window.swap({ direction = "l" }), { description = "Swap with left window" })
bind(modShift("J"), hl.dsp.window.swap({ direction = "d" }), { description = "Swap with down window" })
bind(modShift("K"), hl.dsp.window.swap({ direction = "u" }), { description = "Swap with up window" })
bind(modShift("L"), hl.dsp.window.swap({ direction = "r" }), { description = "Swap with right window" })
bind(altShift("H"), hl.dsp.window.move({ direction = "l" }), { description = "Move window left" })
bind(altShift("L"), hl.dsp.window.move({ direction = "r" }), { description = "Move window right" })
bind(altShift("K"), hl.dsp.window.move({ direction = "u" }), { description = "Move window up" })
bind(altShift("J"), hl.dsp.window.move({ direction = "d" }), { description = "Move window down" })
bind(mod("mouse:272"), hl.dsp.window.drag(), { mouse = true, description = "Move" })
bind(mod("mouse:273"), hl.dsp.window.resize(), { mouse = true, description = "Resize" })
bind(alt("Tab"), function()
	hl.dispatch(hl.dsp.window.cycle_next())
	hl.dispatch(hl.dsp.window.bring_to_top())
end, { repeating = true })
--
-- # Actions
bind("PRINT", exec(HYPRSCRIPTS .. "/screenshot.sh"), { description = "Take a screenshot" })
bind(modShift("S"), exec("grimblast --notify copy area"), { description = "Copy area to clipboard" })
bind(
	modAlt("F"),
	exec(HYPRSCRIPTS .. "/screenshot.sh --instant"),
	{ description = "Take an instant full-screen screenshot" }
)
bind(
	modAlt("S"),
	exec(HYPRSCRIPTS .. "/screenshot.sh --instant-area"),
	{ description = "Take an instant area screenshot" }
)
bind(mod("X"), exec("qs ipc call power toggle"), { description = "Start Power Menu" })
bind(mod("N"), exec("waypaper --random"), { description = "Change the wallpaper" })
bind(modShift("N"), exec("waypaper "), { description = "Open wallpaper selector" })
-- bind(modControl("K"), require("lib.keybindings").show, { description = "Show keybindings" })
bind(modShift("B"), exec("~/.config/waybar/launch.sh"))
bind(modControl("B"), exec("~/.config/waybar/toggle.sh"))
bind(modShift("R"), function()
	hl.dispatch(exec("hyprctl reload"))
	require("lib.notifications").notify({ title = "Hyprland", message = "Config reloaded" })
end)
-- # Workspaces
bind(mod("TAB"), exec("qs -p ~/.config/quickshell/overview ipc call overview toggle"))
bind(mod("1"), hl.dsp.focus({ workspace = 1, on_current_monitor = true }), { description = "Focus Workspace 1" })
bind(mod("2"), hl.dsp.focus({ workspace = 2, on_current_monitor = true }), { description = "Focus Workspace 2" })
bind(mod("3"), hl.dsp.focus({ workspace = 3, on_current_monitor = true }), { description = "Focus Workspace 3" })
bind(mod("4"), hl.dsp.focus({ workspace = 4, on_current_monitor = true }), { description = "Focus Workspace 4" })
bind(mod("5"), hl.dsp.focus({ workspace = 5, on_current_monitor = true }), { description = "Focus Workspace 5" })
bind(mod("6"), hl.dsp.focus({ workspace = 6, on_current_monitor = true }), { description = "Focus Workspace 6" })
bind(mod("7"), hl.dsp.focus({ workspace = 7, on_current_monitor = true }), { description = "Focus Workspace 7" })
bind(mod("8"), hl.dsp.focus({ workspace = 8, on_current_monitor = true }), { description = "Focus Workspace 8" })
bind(mod("9"), hl.dsp.focus({ workspace = 9, on_current_monitor = true }), { description = "Focus Workspace 9" })
bind(mod("0"), hl.dsp.focus({ workspace = 10, on_current_monitor = true }), { description = "Focus Workspace 10" })
--
bind(modShift("1"), hl.dsp.window.move({ workspace = 1 }), { description = "Move active window to workspace 1" })
bind(modShift("2"), hl.dsp.window.move({ workspace = 2 }), { description = "Move active window to workspace 2" })
bind(modShift("3"), hl.dsp.window.move({ workspace = 3 }), { description = "Move active window to workspace 3" })
bind(modShift("4"), hl.dsp.window.move({ workspace = 4 }), { description = "Move active window to workspace 4" })
bind(modShift("5"), hl.dsp.window.move({ workspace = 5 }), { description = "Move active window to workspace 5" })
bind(modShift("6"), hl.dsp.window.move({ workspace = 6 }), { description = "Move active window to workspace 6" })
bind(modShift("7"), hl.dsp.window.move({ workspace = 7 }), { description = "Move active window to workspace 7" })
bind(modShift("8"), hl.dsp.window.move({ workspace = 8 }), { description = "Move active window to workspace 8" })
bind(modShift("9"), hl.dsp.window.move({ workspace = 9 }), { description = "Move active window to workspace 9" })
bind(modShift("0"), hl.dsp.window.move({ workspace = 10 }), { description = "Move active window to workspace 10" })

-- # Fn keys
bind("XF86MonBrightnessUp", exec("brightnessctl -e4 -n2 set 5%+"), { description = "Increase brightness by 5%" })
bind("XF86MonBrightnessDown", exec("brightnessctl -e4 -n2 set 5%-"), { description = "Reduce brightness by 5%" })
bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { description = "Reduce volume by 5%" })
bind(
	"XF86AudioRaiseVolume",
	exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ description = "Increase volume by 5%" }
)
bind("XF86AudioMute", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { description = "Toggle mute" })
bind(
	"XF86AudioMicMute",
	exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ description = "Toggle microphone mute" }
)
bind("XF86AudioPlay", exec("playerctl play-pause"), { description = "Toggle play/pause" })
bind("XF86AudioPause", exec("playerctl pause"), { description = "Toggle play/pause" })
bind("XF86AudioNext", exec("playerctl next"), { description = "Play next track" })
bind("XF86AudioPrev", exec("playerctl previous"), { description = "Play previous track" })

bind("XF86Calculator", exec("~/.config/ml4w/settings/calculator.sh"), { description = "Open calculator" })
-- bind("XF86Lock", exec("hyprlock"), { description = "Open screenlock" })
--
bind(
	"code:238",
	exec("brightnessctl -d smc::kbd_backlight s +10"),
	{ description = "Increase keyboard backlight brightness" }
)
bind(
	"code:237",
	exec("brightnessctl -d smc::kbd_backlight s 10-"),
	{ description = "Decrease keyboard backlight brightness" }
)

-- bind = SUPER, mouse:277, exec, notify-send "MX forward button pressed"
bind("mouse:277", hl.dsp.window.kill())

bind(mod("G"), require("lib.game_mode").toggle)
-- bind(mod("G"), function()
-- 	local is_gamemode = hl.get_config("decoration.rounding")
-- 	if is_gamemode ~= 0 then
-- 		hl.config({
-- 			decoration = {
-- 				rounding = 0,
-- 				active_opacity = 1.0,
-- 				inactive_opacity = 0.9,
-- 				fullscreen_opacity = 1.0,
--
-- 				shadow = {
-- 					enabled = false,
-- 				},
--
-- 				blur = {
-- 					enabled = false,
-- 				},
-- 			},
-- 		})
-- 		exec("hyprctl reload")
-- 	else
-- 		hl.config({
-- 			decoration = {
-- 				rounding = 10,
-- 				rounding_power = 4,
-- 				active_opacity = 1.0,
-- 				inactive_opacity = 0.9,
-- 				fullscreen_opacity = 1.0,
--
-- 				shadow = {
-- 					enabled = true,
-- 					range = 32,
-- 					render_power = 2,
-- 					color = "rgba(00000050)",
-- 				},
--
-- 				blur = {
-- 					enabled = true,
-- 					size = 8,
-- 					passes = 4,
-- 					new_optimizations = true,
-- 					ignore_opacity = true,
-- 					xray = true,
-- 					vibrancy = 0.1696,
-- 					-- popups = true,
-- 					-- popups_ignorealpha = 0.2,
-- 					-- input_methods = true,
-- 				},
-- 			},
-- 		})
-- 		exec("hyprctl reload")
-- 	end
-- 	-- require("conf.decorations.gamemode")
-- end)

-- Legacy (Unused)
-- bind = $mainMod, S, exec, $HYPRSCRIPTS/screenshot.sh                                     # Take a screenshot
-- bind = $mainMod CTRL, F, exec, $HYPRSCRIPTS/screenshot.sh --instant                       # Take an instant full-screen screenshot
-- bind = $mainMod CTRL, S, exec, grimblast --notify copysave area                           # Take an instant area screenshot
-- bind = $mainMod SHIFT, S, exec, grimblast --notify copy area                              # Take an instant area screenshot and copy to clipboard

-- bind = $mainMod SHIFT, A, exec, $HYPRSCRIPTS/toggle-animations.sh                         # Toggle animations
-- bind = $mainMod ALT, A, exec, $HYPRSCRIPTS/text-extractor.sh                              # Extract text from an area
-- bind = $mainMod SHIFT, T, workspaceopt, allfloat                                            # Toggle all windows into floating mode
-- bind = ALT, H, focusmonitor, l                                                              # Focus left monitor
-- bind = ALT, L, focusmonitor, r                                                              # Focus right monitor
-- bind = $mainMod ALT, J, changegroupactive, f                                              # Next window in group
-- bind = $mainMod ALT, K, changegroupactive, b                                              # Prev window in group
-- bind = $mainMod ALT, L, changegroupactive, f                                                # Next window in group
-- bind = $mainMod ALT, H, changegroupactive, b                                                # Prev window in group
-- # bind = $mainMod ALT SHIFT, l, movegroupwindow
-- # bind = $mainMod ALT SHIFT, h, movegroupwindow, b
-- bind = $mainMod SHIFT, right, resizeactive, 100 0                                           # Increase window width with keyboard
-- bind = $mainMod SHIFT, left, resizeactive, -100 0                                           # Reduce window width with keyboard
-- bind = $mainMod SHIFT, down, resizeactive, 0 100                                            # Increase window height with keyboard
-- bind = $mainMod SHIFT, up, resizeactive, 0 -100                                             # Reduce window height with keyboard
-- bind = $mainMod, G, togglegroup                                                             # Toggle window group
--
--
--
-- # bind = $mainMod, Tab, workspace, m+1       # Open next workspace
-- # bind = $mainMod SHIFT, Tab, workspace, m-1 # Open previous workspace
--
-- bind = $mainMod CTRL, 1, exec, $HYPRSCRIPTS/moveTo.sh 1  # Move all windows to workspace 1
-- bind = $mainMod CTRL, 2, exec, $HYPRSCRIPTS/moveTo.sh 2  # Move all windows to workspace 2
-- bind = $mainMod CTRL, 3, exec, $HYPRSCRIPTS/moveTo.sh 3  # Move all windows to workspace 3
-- bind = $mainMod CTRL, 4, exec, $HYPRSCRIPTS/moveTo.sh 4  # Move all windows to workspace 4
-- bind = $mainMod CTRL, 5, exec, $HYPRSCRIPTS/moveTo.sh 5  # Move all windows to workspace 5
-- bind = $mainMod CTRL, 6, exec, $HYPRSCRIPTS/moveTo.sh 6  # Move all windows to workspace 6
-- bind = $mainMod CTRL, 7, exec, $HYPRSCRIPTS/moveTo.sh 7  # Move all windows to workspace 7
-- bind = $mainMod CTRL, 8, exec, $HYPRSCRIPTS/moveTo.sh 8  # Move all windows to workspace 8
-- bind = $mainMod CTRL, 9, exec, $HYPRSCRIPTS/moveTo.sh 9  # Move all windows to workspace 9
-- bind = $mainMod CTRL, 0, exec, $HYPRSCRIPTS/moveTo.sh 10 # Move all windows to workspace 10
--
-- bind = $mainMod, mouse_down, workspace, e+1  # Open next workspace
-- bind = $mainMod, mouse_up, workspace, e-1    # Open previous workspace
-- bind = $mainMod CTRL, down, workspace, empty # Open the next empty workspace
--
