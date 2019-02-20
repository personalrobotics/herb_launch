#!/bin/bash
# Start HERB2 functionalities in tmux sessions
# to kill all sessions:      pkill -f tmux
# to attach to a session:    tmux a -t <session_name>
# to detach from a session:  <ctrl + b> + d

# run code in new window in a session. Make session if it doesn't exist
function launcher {
    tmux has-session -t $1 2>/dev/null
    if [ "$?" -eq 0 ] ; then
        tmux switch-client -t $1 2>/dev/null
    else
        echo "Created new tmux session: $1"
        tmux new-session -s $1 -d 2>/dev/null
    fi
    tmux new-window
    tmux rename-window $2
    echo "Created new tmux window: $1:$2"
    tmux send-keys -t $1:$2 "$3" Enter
}

cd /home/herb_admin/herb2_ws
source $(catkin locate)/devel/setup.bash

launcher "alexa" "rosbridge" "source /opt/ros/indigo/setup.bash && roslaunch rosbridge_server rosbridge_websocket.launch"
launcher "alexa" "lambda" "cd $(catkin locate)/src/MAGICAL_infra && bst proxy lambda index.js"
launcher "alexa" "obj_grounding" "source $(catkin locate)/devel/setup.bash && cd $(catkin locate)/src/MAGICAL_infra && python obj_grounding.py"
