#!/bin/bash

rosservice call /controller_manager/switch_controller "start_controllers:
- 'right_gravity_compensation_controller'
- 'left_gravity_compensation_controller'
stop_controllers:
- 'bimanual_trajectory_controller'
strictness: 2"

