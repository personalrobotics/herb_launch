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

export ROS_MASTER_URI=http://herb0:11311/

#pr_herb2_launcher "kinect2"       "kinect2_bridge_cpu.launch"
pr_herb2_launcher "multisense"    "multisense.launch"
pr_herb2_launcher "apriltags"	  "apriltags_multisense.launch"
