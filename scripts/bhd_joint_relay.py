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
        tf_prefix + '/j00',
        tf_prefix + '/j11',
        tf_prefix + '/j11',
        tf_prefix + '/j21',
        tf_prefix + '/j12',
        tf_prefix + '/j12',
        tf_prefix + '/j22',
    ]
    jointstate_msg.position += [ handstate_msg.positions[0] ]
    jointstate_msg.position += handstate_msg.inner_links
    jointstate_msg.position += handstate_msg.outer_links

    jointstate_pub.publish(jointstate_msg)
    

def main():
    global jointstate_pub, tf_prefix

    rospy.init_node('bhd_joint_relay')

    tf_prefix = rospy.get_param('tf_prefix', '')

    jointstate_pub = rospy.Publisher('/joint_states', JointState)
    wamstate_sub = rospy.Subscriber('handstate', BHState, handstate_callback)

    rospy.spin()

if __name__ == '__main__':
    main()
