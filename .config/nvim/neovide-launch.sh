#!/bin/bash

# Get the window ID of the terminal (assumes only one terminal is focused)
TERMINAL_WIN_ID=$(xdotool getactivewindow)

# Hide (unmap) the terminal window
xdotool windowunmap $TERMINAL_WIN_ID

# Launch Neovide as a background process
neovide &

# Get the PID of Neovide
NEOVIDE_PID=$!

# Wait for Neovide to exit
wait $NEOVIDE_PID

# Show (remap) the terminal window
xdotool windowmap $TERMINAL_WIN_ID
