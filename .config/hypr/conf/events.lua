hl.on("window.fullscreen", function()
	hl.dispatch(hl.dsp.layout("focus r"))
	hl.dispatch(hl.dsp.layout("focus l"))
end)

hl.on("window.urgent", function(win)
	hl.dispatch(hl.dsp.focus({ window = win }))
end)
