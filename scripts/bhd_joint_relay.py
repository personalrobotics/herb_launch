#!/usr/bin/env python
import rospy
from sensor_msgs.msg import JointState
from owd_msgs.msg import BHState


def handstate_callback(handstate_msg):
    assert len(handstate_msg.positions) == 4
    assert len(handstate_msg.inner_links) == 3
    assert len(handstate_msg.outer_links) == 3

    jointstate_msg = JointState()
    jointstate_msg.header.stamp = handstate_msg.header.stamp
    jointstate_msg.name = [
        joint_prefix + '00',
        # Joint j01 is a mimic joint that is published by robot_state_publisher.
        joint_prefix + '01',
        joint_prefix + '11',
        joint_prefix + '21',
        # TODO: These are not currently being published. See below.
        #joint_prefix + '02',
        #joint_prefix + '12',
        #joint_prefix + '22',
    ]
    jointstate_msg.position += [ handstate_msg.positions[3] ]
    jointstate_msg.position += handstate_msg.inner_links

    # TODO: These positions look very wrong, so we'll let robot_state_publisher
    # use the mimic ratios in HERB's URDF to compute the distal joint angles. 
    #jointstate_msg.position += handstate_msg.outer_links

    jointstate_pub.publish(jointstate_msg)
    

def main():
    global jointstate_pub, joint_prefix

    rospy.init_node('bhd_joint_relay')

    joint_prefix = rospy.get_param('joint_prefix', '')

    jointstate_pub = rospy.Publisher('/joint_states', JointState)
    wamstate_sub = rospy.Subscriber('handstate', BHState, handstate_callback)

    rospy.spin()

if __name__ == '__main__':
    main()
