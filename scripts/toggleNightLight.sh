#! /bin/bash

status=$(gsettings get org.gnome.settings-daemon.plugins.color night-light-enabled)
# echo $status
if $status
then
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false
else
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
fi
