#!/bin/sh

notify-send "My cpu got too hot, you got one minute to cool me down"
sleep 2
shutdown +1
zenity --question --text="Did you connect the fan?"
answer=$?
if [ answer ]
then
    shutdown -c; notify-send "Shutdown has been canceled";
else
    notify-send "PC is shutting down"
fi

# echo Did you connect the fan?
# while true; do
#     read -p "Did you connect the fan (y/n)? " answer
#     case $answer in
#         [Yy] ) shutdown -c; notify-send "Shutdown has been canceled"; break;;
#         [Nn] ) break;;
#         * ) echo "Please enter y/n";;
#     esac
# done
