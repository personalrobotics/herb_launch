#!/bin/bash
# Start HERB2 functionality in screen sessions
# to kill all sessions: killall -15 screen

function herb2_launcher {
    tmux has-session -t $1 2>/dev/null
    if [ "$?" -eq 0 ] ; then
        echo "WARNING! $1 is already running! (tmux session)"
    elif screen -ls | grep -q $1 ; then
        echo "WARNING! $1 is already running! (screen session)"
    else
        screen -d -S $1 -m bash
        screen -S $1 -p 0 -X stuff "source /home/herb_admin/herb2_ws/devel/setup.bash; $2$(printf \\r)"
    fi
}

function pr_herb2_launcher {
    herb2_launcher $1 "roslaunch herb_launch $2 --wait"
}

export ROS_MASTER_URI=http://herb0:11311/
export PYTHONPATH=$PYTHONPATH:/home/herb_admin/tensorflow_models/research:/home/herb_admin/tensorflow_models/research/slim

#pr_herb2_launcher "kinect2"       "kinect2_bridge_cpu.launch"
pr_herb2_launcher "multisense"    "multisense.launch"
pr_herb2_launcher "apriltags"	  "apriltags_multisense.launch"
pr_herb2_launcher "rcnn_moped"    "rcnn_moped.launch"
