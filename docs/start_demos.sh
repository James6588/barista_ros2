# Launch SImulation+ Navigation + FreeFleet for Barista_1
# FIRST TIME SOMETIMES FAILS, is a GAzebo BUG
cd ~/ros2_ws
source install/setup.bash;reset;ros2 launch barista_ros2_ff main_multiple_robots.launch.xml 

# Start RMF for barista 1
cd ~/ros2_ws
source install/setup.bash;ros2 launch barista_rmf_gazebo start_rmf_turtlebotworld.launch.xml

# Start firefox page to be able to send command
firefox https://open-rmf.github.io/rmf-panel-js/


# TESTS for NAvigation 2 multiple robots
colcon build --packages-select barista_ros2_ff barista_ros2_navigation nav2_bringup

# Start sim
source install/setup.bash;reset;ros2 launch barista_ros2_ff main_multiple_robots.launch.xml 

source install/setup.bash;reset;ros2 launch barista_ros2_ff start_barista1_nav.launch.xml