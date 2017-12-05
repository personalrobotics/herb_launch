#!/usr/bin/env python
import rospy
from sensor_msgs.msg import JointState
from segway_rmp.msg import SegwayStatusStamped


def segway_callback(segway_msg):
    jointstate_msg = JointState()
    jointstate_msg.header.stamp = segway_msg.header.stamp
    jointstate_msg.name = [ 
        '/segway_wheel_left',
        '/segway_wheel_right',
    ]
    jointstate_msg.position = [
        -segway_msg.segway.left_wheel_displacement,
        -segway_msg.segway.right_wheel_displacement,
    ]
    jointstate_msg.velocity = [
        -segway_msg.segway.left_wheel_velocity,
        -segway_msg.segway.right_wheel_velocity,
    ]
    jointstate_msg.effort = [
        -segway_msg.segway.left_motor_torque,
        -segway_msg.segway.right_motor_torque,
    ]

    jointstate_pub.publish(jointstate_msg)
    

def main():
    global jointstate_pub, joint_prefix

    rospy.init_node('segway_relay')

    jointstate_pub = rospy.Publisher('/joint_states', JointState)
    wamstate_sub = rospy.Subscriber('segway_status', SegwayStatusStamped,
                                    segway_callback)

    rospy.spin()

if __name__ == '__main__':
    main()
