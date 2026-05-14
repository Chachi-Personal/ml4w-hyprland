local M = {}

M.is_active = false

M.toggle = function()
	if M.is_active then
		hl.config({
			decoration = {
				rounding = 10,
				rounding_power = 4,
				active_opacity = 1.0,
				inactive_opacity = 0.9,
				fullscreen_opacity = 1.0,

				shadow = {
					enabled = true,
					range = 32,
					render_power = 2,
					color = "rgba(00000050)",
				},

				blur = {
					enabled = true,
					size = 8,
					passes = 4,
					new_optimizations = true,
					ignore_opacity = true,
					xray = true,
					vibrancy = 0.1696,
					-- popups = true,
					-- popups_ignorealpha = 0.2,
					-- input_methods = true,
				},
			},
		})
	else
		hl.config({
			decoration = {
				rounding = 0,
				rounding_power = 2,
				active_opacity = 1.0,
				inactive_opacity = 1,
				fullscreen_opacity = 1.0,

				shadow = {
					enabled = false,
				},

				blur = {
					enabled = false,
				},
			},
		})
	end
	M.is_active = not M.is_active
	hl.notification.create({
		text = M.is_active and "Game mode enabled" or "Game mode disabled",
		duration = 2000,
	})
	hl.dispatch(hl.dsp.exec_cmd("hyprctl dispatch aforcerendererreload"))
	-- hl.dispatch(hl.dsp.exec_cmd("hyprctl reload"))
end

return M
