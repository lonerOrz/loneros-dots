#!/usr/bin/env bash

SCRIPTSDIR=$HOME/.config/hypr/scripts
UserScripts=$HOME/.config/hypr/UserScripts

# Define file_exists function
file_exists() {
  if [ -e "$1" ]; then
    return 0 # File exists
  else
    return 1 # File does not exist
  fi
}

hyprctl reload

# hyprpanel应用配色
pkill waybar
pkill swaync
hyprpanel -q
hyprpanel &

# ags
pkill ags && ags &

# cava
pkill -USR1 cava

# spotify
# 检查 Flatpak 版 Spotify 是否在运行
# if flatpak ps | grep -q "com.spotify.Client"; then
#   spicetify apply
#   flatpak kill com.spotify.Client
#   sleep 2 # 等待 2 秒确保进程完全关闭
#   flatpak run com.spotify.Client &
# fi

# # Relaunching rainbow borders if the script exists
# sleep 1
if file_exists "${UserScripts}/RainbowBorders.sh"; then
  ${UserScripts}/RainbowBorders.sh &
fi

exit 0
