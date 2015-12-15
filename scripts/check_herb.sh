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
    RESULTS=`timeout 2.0 rostopic echo -n 1 $1`
    if echo -e ${RESULTS} | grep -q "header:"; then
        echo -e "$1: \033[0;36m RUNNING \033[0m"
    else
        echo -e "$1: \033[0;31m NOT RUNNING \033[0m"
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

echo -e "Checking ros topics:" # Need to generate actual useful list
rostopic_check "/tf"
rostopic_check "/tf/transforms"
rostopic_check "/joint_states"
rostopic_check "/rosout"

# Put other misc checks here?
