#!/bin/bash
# Start HERB functionality in screen sessions
# Mike Dawson-Haggerty 10/8/2014
# to kill all sessions: killall -15 screen

function launcher {
    if screen -ls | grep -q $1; then
        echo "WARNING! $1 is already running!"
    else
        screen -d -S $1 -m bash
        screen -S $1 -p 0 -X stuff "source /home/herb_home/shared/herb0_ws/devel/setup.bash; $2$(printf \\r)"
    fi
}

function pr_launcher {
    launcher $1 "roslaunch herb_launch $2 --wait"
}

if [ $(hostname) != 'herb0.personalrobotics.ri.cmu.edu' ]
then
    echo 'ERROR: HERB must be launched from herb0'
    exit
fi

launcher    "core"         "roscore"
sleep 5s
pr_launcher "state_pub"    "state_publisher.launch"
pr_launcher "ros_control"  "ros_control.launch"
pr_launcher "apriltags"    "apriltags.launch"
pr_launcher "joystick"     "joystick.launch"
pr_launcher "segway"       "segway.launch"
pr_launcher "localization" "localization.launch"
pr_launcher "navigation"   "navigation.launch"
pr_launcher "talker"       "talker.launch"
pr_launcher "diag_logs"    "diagnostic_logging.launch"
ssh prdemo@herb2 ./shared/ros_ws/src/herb_launch/scripts/start_herb2.sh