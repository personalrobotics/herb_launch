#!/bin/bash
# Start HERB functionality in screen sessions
# Mike Dawson-Haggerty 10/8/2014
# to kill all sessions: killall -15 screen

function launcher {
    if (screen -ls | grep -q $1) 
    then
	echo "WARNING! $1 is already running!"
    else
	screen -d -S $1 -m bash
	screen -S $1 -p 0 -X stuff "source /home/prdemo/ros-hydro/use-hydro.sh; $2$(printf \\r)"	
    fi
}

function pr_launcher {
    launcher $1 "roslaunch herb_launch $2 --wait"
}

launcher    "core"       "roscore"
pr_launcher "transforms" "transforms.launch"
pr_launcher "right_arm"  "right_arm.launch"
pr_launcher "head"       "head.launch"
pr_launcher "apriltags"  "apriltags.launch"

 
    

