#!/bin/bash
# Start HERB2 functionalities in tmux sessions
# to kill all sessions:      pkill -f tmux
# to attach to a session:    tmux a -t <session_name>
# to detach from a session:  <ctrl + b> + d

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

function pr_herb2_launcher {
    launcher $1 "roslaunch herb_launch $2 --wait"
}

export ROS_MASTER_URI=http://herbx:11311/

export PYTHONPATH=$PYTHONPATH:/home/herb_admin/tensorflow_models/research:/home/herb_admin/tensorflow_models/research/slim

#pr_herb2_launcher "kinect2"       "kinect2_bridge_cpu.launch"
pr_herb2_launcher "multisense"    "multisense.launch"
pr_herb2_launcher "apriltags"	  "apriltags_multisense.launch"
pr_herb2_launcher "rcnn_moped"    "rcnn_moped.launch"

sleep 5s
rosrun dynamic_reconfigure dynparam set multisense lighting true
rosrun dynamic_reconfigure dynparam set multisense led_duty_cycle 0.04

