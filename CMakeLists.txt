cmake_minimum_required(VERSION 2.8.3)
project(herb_launch)

find_package(catkin REQUIRED)

catkin_package()

# backslashes important
install(
  DIRECTORY
  config
  launch/
  libbarrett_config
  DESTINATION "${CATKIN_PACKAGE_SHARE_DESTINATION}"
)
