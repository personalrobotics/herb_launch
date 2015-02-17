#!/usr/bin/env python
import rospy
from sensor_msgs.msg import JointState
from owd_msgs.msg import WAMState


def wamstate_callback(wamstate_msg):
    num_dof = len(wamstate_msg.positions)

    assert len(wamstate_msg.positions) == num_dof
    assert len(wamstate_msg.velocities) == num_dof
    assert len(wamstate_msg.torques) == num_dof

    jointstate_msg = JointState()
    jointstate_msg.header.stamp = wamstate_msg.header.stamp
    jointstate_msg.name = [ '{:s}j{:d}'.format(joint_prefix, idof + 1)
                            for idof in xrange(num_dof) ]
    jointstate_msg.position = wamstate_msg.positions
    jointstate_msg.velocity = wamstate_msg.velocities
    jointstate_msg.effort = wamstate_msg.torques

    jointstate_pub.publish(jointstate_msg)
    

def main():
    global jointstate_pub, joint_prefix

    rospy.init_node('owd_joint_relay')

    joint_prefix = rospy.get_param('joint_prefix', '')

    jointstate_pub = rospy.Publisher('/joint_states', JointState)
    wamstate_sub = rospy.Subscriber('wamstate', WAMState, wamstate_callback)

    rospy.spin()

if __name__ == '__main__':
    main()
