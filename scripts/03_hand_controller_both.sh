#!/bin/bash

rosservice call /controller_manager/switch_controller "start_controllers:
- 'right_hand_controller'
- 'left_hand_controller'
strictness: 2"

