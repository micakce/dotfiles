#!/bin/zsh

# Scrip to show temp in tmux status bar ./.tmux.conf:69

temp=$(sensors | grep -oP 'Package.*?\+\K[0-9]+')

if [ $temp -gt 80 ];
then
    echo "#[fg=colour233,bg=colour9,bold] $temp°C";
elif [ $temp -gt 65 ];
then
    echo "#[fg=colour233,bg=colour3,bold] $temp°C";
elif [ $temp -gt 40 ];
then
    echo "#[fg=colour233,bg=colour2,bold] $temp°C";
elif [ $temp -gt 30 ];
then
    echo "#[fg=colour233,bg=colour12,bold] $temp°C";
fi
