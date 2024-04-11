#!/bin/bash

#current dir
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Call API if times.json doesn't exists
if [ ! -f "$DIR/times.json" ]; then
    "$DIR/getSunriseAndSunset.sh"
    exit 0
fi

# Read sunrise and sunset from JSON
sunrise=$(jq -r '.sunrise' "$DIR/times.json")
sunset=$(jq -r '.sunset' "$DIR/times.json")
now=$(date +%H:%M)

#Choose the theme based on the current time
if [[ "$now" > "$sunrise" ]] && [[ "$now" < "$sunset" ]]; then
  theme2Stablish='Yaru-light'
  colorScheme='prefer-light'
else
  theme2Stablish='Yaru-dark'
  colorScheme='prefer-dark'
fi

# Apply theme
theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
if [ "$theme" != "$theme2Stablish" ];
then
  # gsettings needs this environment variable to work. If the command 
  # is executed manually, the system already has it configured.
  # But when it is run from cron it does not find it.
  # For more information read https://www.baeldung.com/linux/gsettings-remote-shell
  PID=$(pgrep -o gnome-shell)
  export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2-)
	
  gsettings set org.gnome.desktop.interface gtk-theme $theme2Stablish
	gsettings set org.gnome.desktop.interface color-scheme $colorScheme
fi