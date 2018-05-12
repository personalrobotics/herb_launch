#!/bin/bash

run talker say.py "Gravity compensation: right"
rosrun talker say.py "3"
rosrun talker say.py "2"
rosrun talker say.py "1"
rosservice call /controller_manager/switch_controller "start_controllers:
- 'right_gravity_compensation_controller'
strictness: 2"

