#!/bin/bash
# Check HERB status
# Aaron M. Johnson 12/15/2015
# based on start_herb.sh by Mike Dawson-Haggerty


function launcher_check {
    if screen -ls | grep -q $1; then
        echo -e "$1: \033[0;36m FOUND \033[0m"
    else
        echo -e "$1: \033[0;31m NOT FOUND \033[0m"
    fi
}

function rostopic_check {
    RESULTS=`timeout 2.0 rostopic echo -n 1 $1 2>&1`
    if echo -e ${RESULTS} | grep -q "header:"; then
        echo -e "$1: \033[0;36m RUNNING \033[0m"
    else
        echo -e "$1: \033[0;31m NOT RUNNING \033[0m"
    fi
}

function rosdiag_check {
    RESULTS=`timeout 2.0 rostopic echo -n 1 /diagnostics --filter "'$1' in m.status[0].name" 2>&1`
    if echo -e ${RESULTS} | grep -q "header:"; then
        echo -e "/diagnostics $1: \033[0;36m RUNNING \033[0m"
    else
        echo -e "/diagnostics $1: \033[0;31m NOT RUNNING \033[0m"
    fi
}

function rostf_check {
    RESULTS=`timeout 1.0 rosrun tf tf_echo herb_base $1 2>&1`
    if echo -e ${RESULTS} | grep -q "Translation:"; then
        echo -e "herb_base -> $1: \033[0;36m FOUND \033[0m"
    else
        echo -e "herb_base -> $1: \033[0;31m NOT FOUND \033[0m"
    fi
}

if [ $(hostname) != 'herb0.personalrobotics.ri.cmu.edu' ]
then
    echo -e "\033[0;32m WARNING: Cannot check screens unless running on herb0 \033[0m"
else
    echo -e "Checking screens:"

    launcher_check  "core"        
    #launcher_check "transforms"   
    launcher_check "state_pub"   
    launcher_check "left_arm"    
    launcher_check "right_arm"   
    launcher_check "head"        
    launcher_check "apriltags"   
    launcher_check "joystick"    
    launcher_check "segway"      
    launcher_check "localization"
    launcher_check "navigation"  
    launcher_check "talker"      
fi

echo -e ""
echo -e "Checking ros topics:"
rostopic_check "/right/owd/wamstate"
rostopic_check "/right/owd/handstate"
rostopic_check "/right/owd/forcetorque"
rostopic_check "/left/owd/wamstate"
rostopic_check "/left/owd/handstate"
rostopic_check "/left/owd/forcetorque"
rostopic_check "/head/owd/wamstate"
rostopic_check "/odom"
rostopic_check "/stargazer/robot_pose_array"
rostopic_check "/segway/segway_status"
rostopic_check "/navcontroller/navstatus"
rosdiag_check "localization_global"
rostopic_check "/head/kinect2/qhd/camera_info"
rostopic_check "/apriltags_kinect2/detections"
rostopic_check "/say/status"
rosdiag_check "joy"

echo -e ""
echo -e "Checking ros tf transforms from herb_base:"
rostf_check "left/wam7"
rostf_check "left/hand_base"
rostf_check "right/wam7"
rostf_check "right/hand_base"
rostf_check "head/wam2"
#rostf_check "head/kinect2_link"
rostf_check "/head/kinect2_rgb_optical_frame"
rostf_check "stargazer_lens"
#rostf_check "base_hokuyo_right"
#rostf_check "base_hokuyo_left"
#rostf_check "base_hokuyo_front"


# Put other misc checks here?
