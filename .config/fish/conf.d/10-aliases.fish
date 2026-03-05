# -----------------------------------------------------
# ALIASES
# -----------------------------------------------------

# -----------------------------------------------------
# General
# -----------------------------------------------------
alias c='clear'
alias cd='z'
alias clear='clear && fastfetch'
alias tree='tree -I "node_moduels|venv|vendor"'
alias nf='fastfetch'
alias pf='fastfetch'
alias ff='fastfetch'
alias eza='eza --color=auto --group-directories-first --icons=always'
alias ls='eza -a --icons=always'
alias la='eza -a'
alias ll='eza -al --icons=always'
alias l='eza -lah'
alias l.='eza -lA | grep "^\."'
alias lt='eza -a --tree --level=1 --icons=always'
alias shutdown='systemctl poweroff'
alias v='$EDITOR'
alias vi='$EDITOR'
alias vim='$EDITOR'
alias ts='~/.config/ml4w/scripts/arch/snapshot.sh'
alias wifi='nmtui'
alias cleanup='~/.config/ml4w/scripts/arch/cleanup.sh'
alias which='type'
alias open='xdg-open'
alias grep='grep --color=auto'
alias wget='wget -c'
alias pacman='pacman --color auto'
alias update='pacman -Syyu'
alias ifconfig='ip -s -c -h a'
alias cat='bat'
alias yay='paru'
alias yeet='paru -Rns'

# -----------------------------------------------------
# ML4W Apps
# -----------------------------------------------------
alias ml4w='flatpak run com.ml4w.welcome'
alias ml4w-settings='flatpak run com.ml4w.settings'
alias ml4w-calendar='flatpak run com.ml4w.calendar'
alias ml4w-hyprland='flatpak run com.ml4w.hyprlandsettings'
alias ml4w-sidebar='flatpak run com.ml4w.sidebar'
alias ml4w-options='ml4w-hyprland-setup -m options'
alias ml4w-diagnosis='~/.config/hypr/scripts/diagnosis.sh'
alias ml4w-hyprland-diagnosis='~/.config/hypr/scripts/diagnosis.sh'
alias ml4w-qtile-diagnosis='~/.config/ml4w/qtile/scripts/diagnosis.sh'
alias ml4w-update='~/.config/ml4w/scripts/installupdates.sh'

# -----------------------------------------------------
# Window Managers
# -----------------------------------------------------

alias Qtile='startx'
# Hyprland with Hyprland

# -----------------------------------------------------
# Git
# -----------------------------------------------------
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gst="git stash"
alias gsp="git stash; git pull"
alias gfo="git fetch origin"
alias gcheck="git checkout"
alias gcredential="git config credential.helper store"

# -----------------------------------------------------
# Scripts
# -----------------------------------------------------
alias ascii='~/.config/ml4w/scripts/figlet.sh'

# -----------------------------------------------------
# System
# -----------------------------------------------------
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# -----------------------------------------------------
# Qtile
# -----------------------------------------------------
alias res1='xrandr --output DisplayPort-0 --mode 2560x1440 --rate 120'
alias res2='xrandr --output DisplayPort-0 --mode 1920x1080 --rate 120'
alias setkb='setxkbmap de;echo "Keyboard set back to de."'

# -----------------------------------------------------
# Programming
# -----------------------------------------------------
alias mysql "mariadb"
alias lg "lazygit"
alias sail "[ -f sail ] && bash sail || bash vendor/bin/sail"
alias r "R_AUTO_START=true nvim"
alias tm "tmuxinator"
alias yarnstart="yarn start && echo -e '\033c'"

# -----------------------------------------------------
# Others
# -----------------------------------------------------
alias tobash "sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh "sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"
alias tofish "sduo chsh $USER -s /bin/fish && echo 'Now log out.'"

# ---------------------------------------------------
# Abbreviations
# ---------------------------------------------------
abbr --add dotdot --regex '^\.\.+$' --function multicd
abbr del "trash"
abbr toclip "xclip -selection clipboard"
