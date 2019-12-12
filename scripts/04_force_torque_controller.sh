#!/bin/bash

rosservice call /controller_manager/switch_controller "start_controllers:
- 'force_torque_sensor_controller'
strictness: 2"
