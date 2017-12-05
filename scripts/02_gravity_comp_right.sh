#!/bin/bash

run talker say.py "gravity compensation, right"
sleep 1s
rosrun talker say.py "3"
sleep 1s
rosrun talker say.py "2"
sleep 1s
rosrun talker say.py "1"
sleep 1s
rosservice call /controller_manager/switch_controller "start_controllers:
- 'right_gravity_compensation_controller'
strictness: 2"

