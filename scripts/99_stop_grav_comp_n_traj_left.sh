#!/bin/bash

rosservice call /controller_manager/switch_controller "start_controllers:
- 'left_trajectory_controller'
stop_controllers:
- 'left_gravity_compensation_controller'
strictness: 2"

