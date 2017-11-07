#!/bin/bash
# Start HERB3  functionality in screen sessions
# Jimmy Jin 4/25/2017
# to kill all sessions: killall -15 screen

function launcher {
    tmux has-session -t $1 2>/dev/null
    if [ "$?" -eq 0 ] ; then
        echo "WARNING! $1 is already running! (tmux session)"
    elif screen -ls | grep -q $1 ; then
        echo "WARNING! $1 is already running! (screen session)"
    else
        screen -d -S $1 -m bash
        screen -S $1 -p 0 -X stuff "source /home/herb_home/ros_ws/devel/setup.bash && $2$(printf \\r)"
    fi
}

function pr_launcher {
    launcher $1 "roslaunch herb_launch $2 --wait"
}

launcher    "core"         "roscore"
sleep 5s
pr_launcher "state_pub"    "state_publisher.launch"
pr_launcher "localization" "localization.launch"
pr_launcher "navigation"   "navigation.launch"
pr_launcher "static_map"   "static_map.launch"
