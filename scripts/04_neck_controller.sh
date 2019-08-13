#!/bin/bash

function launcher {
    tmux has-session -t $1 2>/dev/null
    if [ "$?" -eq 0 ] ; then
        echo "WARNING! $1 is already running! (tmux session)"
    elif screen -ls | grep -q $1 ; then
        echo "WARNING! $1 is already running! (screen session)"
    else
        echo "Creating a new tmux session: $1"
	tmux new-session -d -s $1
	tmux send -t $1 "source $(catkin locate)/devel/setup.bash && $2$(printf \\r)"
    fi
}

function neck_can_reset {
    echo "reset can0 for schunk_neck"
    sudo ifconfig can0 down
    sudo ip link set up can0 type can bitrate 500000 triple-sampling on
    cansend can0 50E#01.92
}

neck_can_reset

launcher "schunk_neck" "roslaunch schunk_pw70_ros schunk_neck.launch"