#!/usr/bin/env bash
TERMINAL=$(cat ~/.config/ml4w/settings/terminal.sh)

"$TERMINAL" --class dotfiles-floating -e env \
    NEWT_COLORS='root=#000000,#000000;window=#000000,#000000;border=#FFFFFF,#000000;listbox=#FFFFFF,#000000;label=#0000FF,#000000;checkbox=#FF0000,#000000;title=#00FF00,#000000;button=#FFFFFF,red;actsellistbox=#FFFFFF,red;actlistbox=#FFFFFF,#2a2a2a;compactbutton=#FFFFFF,#2a2a2a;actcheckbox=#FFFFFF,#0000FF;entry=#949494,#000000;textbox=#0000FF,#000000' \
    nmtui
