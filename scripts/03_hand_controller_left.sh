#!/bin/bash

rosservice call /controller_manager/switch_controller "start_controllers:
- 'left_hand_controller'
strictness: 2"

