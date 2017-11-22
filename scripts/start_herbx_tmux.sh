#!/bin/bash
# Start HERB functionality in screen sessions
# to kill all sessions: pkill -f tmux 

function launcher {
    tmux has-session -t $1 2>/dev/null
    if [ "$?" -eq 0 ] ; then
        echo "WARNING! $1 is already running! (tmux session)"
    elif screen -ls | grep -q $1 ; then
        echo "WARNING! $1 is already running! (screen session)"
    else
        echo "Creating a new tmux session: $1"
	tmux new-session -d -s $1
	tmux send -t $1 "source /home/robot/barrett_testing_ws/devel/setup.bash && $2$(printf \\r)"
    fi
}

function pr_launcher {
    launcher $1 "roslaunch herb_launch $2 --wait"
}

launcher    "core"         "roscore"
sleep 5s
pr_launcher "state_pub"    "state_publisher.launch"
pr_launcher "ros_control"  "ros_control.launch"
#pr_launcher "localization" "localization.launch"
