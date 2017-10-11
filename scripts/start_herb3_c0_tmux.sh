#!/bin/bash
# Start HERB functionality in screen sessions
# to kill all sessions: pkill -f tmux 

function launcher {
    tmux has-session -t $1 2>/dev/null
    if [ "$?" -eq 1 ] ; then
        echo "Creating a new tmux session: $1"
	tmux new-session -d -s $1
	tmux send -t $1 "source /home/herb_admin/herb0_ws/devel/setup.bash && $2$(printf \\r)"
    else
	echo "WARNING! $1 is already running!"
    fi
}

function pr_launcher {
    launcher $1 "roslaunch herb_launch $2 --wait"
}

launcher    "core"         "roscore"
sleep 5s
pr_launcher "state_pub"    "state_publisher.launch"
pr_launcher "localization" "localization.launch"
