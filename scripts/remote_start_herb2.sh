#!/bin/bash
# Start HERB functionality in screen sessions
# Mike Dawson-Haggerty 10/8/2014
# to kill all sessions: killall -15 screen

function herb2_launcher {
    if screen -ls | grep -q $1; then
        echo "WARNING! $1 is already running!"
    else
        screen -d -S $1 -m bash
        screen -S $1 -p 0 -X stuff "source /home/herb_home/shared/herb2_ws/devel/setup.bash; $2$(printf \\r)"
    fi
}

function pr_herb2_launcher {
    herb2_launcher $1 "roslaunch herb_launch $2 --wait"
}

function kinect2_watchdog_launcher {
    herb2_launcher $1 "python /home/herb_home/shared/herb2_ws/src/kinect_watchdog/kinect_watchdog.py"
}

if [ $(hostname) != 'herb2.personalrobotics.ri.cmu.edu' ]
then
    echo 'ERROR: this script must be launched from herb2'
    exit
fi

pr_herb2_launcher "kinect2"       "kinect2_bridge.launch"
kinect2_watchdog_launcher "kinect2_watchdog"