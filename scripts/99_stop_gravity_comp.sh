#!/bin/bash

rosservice call /controller_manager/switch_controller "stop_controllers:
- 'right_gravity_compensation_controller'
- 'left_gravity_compensation_controller'"

