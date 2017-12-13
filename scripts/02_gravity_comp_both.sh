#!/bin/bash

rosrun talker say.py "gravity compensation, left, and right"
rosrun talker say.py "3"
rosrun talker say.py "2"
rosrun talker say.py "1"
rosservice call /controller_manager/switch_controller "start_controllers:
- 'left_gravity_compensation_controller'
- 'right_gravity_compensation_controller'
strictness: 2"

