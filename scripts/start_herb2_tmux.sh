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

function neck_can_reset {
    echo "reset can0 for schunk_neck"
    sudo ifconfig can0 down
    sudo ip link set up can0 type can bitrate 500000 triple-sampling on
}

export ROS_MASTER_URI=http://herb0:11311/

export PYTHONPATH=$PYTHONPATH:/home/herb_admin/tensorflow_models/research:/home/herb_admin/tensorflow_models/research/slim

cd /home/herb_admin/herb2_ws/
source $(catkin locate)/devel/setup.bash

neck_can_reset

#pr_herb2_launcher "kinect2"       "kinect2_bridge_cpu.launch"
pr_herb2_launcher "multisense"    "multisense.launch"
pr_herb2_launcher "apriltags"	  "apriltags_multisense.launch"
pr_herb2_launcher "rcnn_moped"    "rcnn_moped.launch"
launcher          "schunk_neck"   "rosrun schunk_neck schunk_neck_node"
launcher          "image_echo"    "rostopic hz /multisense/left/image_rect_color"
launcher          "lidar_echo"    "rostopic hz /multisense/lidar_points2"

sleep 3s
rosrun dynamic_reconfigure dynparam set multisense lighting true
rosrun dynamic_reconfigure dynparam set multisense led_duty_cycle 0.04
rosrun dynamic_reconfigure dynparam set multisense led_duty_cycle 0.01
rosrun dynamic_reconfigure dynparam set multisense motor_speed 1.0
rosservice call /schunk_neck/set_state -- 0 30
sleep 2s

