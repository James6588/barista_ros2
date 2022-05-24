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
colcon build --packages-select barista_ros2_ff barista_ros2_navigation nav2_bringup barista_rmf_gazebo

# Start sim
source install/setup.bash;reset;ros2 launch barista_ros2_ff main_multiple_robots.launch.xml 

# Start battery states
source install/setup.bash;reset;ros2 launch barista_ros2_ff start_multiple_sim_battery.launch.xml

# Start clients

source install/setup.bash;reset;ros2 launch barista_ros2_ff start_ff_client_barista.launch.xml barista_name:=barista_1
source install/setup.bash;reset;ros2 launch barista_ros2_ff start_ff_client_barista.launch.xml barista_name:=barista_2

source install/setup.bash;reset;ros2 launch barista_ros2_ff start_multiple_ff_clients.launch.xml


# Start Navigation for each barista
source install/setup.bash;reset;ros2 launch barista_ros2_ff start_barista1_nav.launch.xml
source install/setup.bash;reset;ros2 launch barista_ros2_ff start_barista2_nav.launch.xml

# Update
# Start Sim and Navigation systems
source install/setup.bash;reset;ros2 launch barista_ros2_ff main_multiple_robots.launch.xml 


############ FF SERVER CLIENT TESTS

# Test the server command sending ( always change the ID, because it ha sto be unique)
ros2 run ff_examples_ros2 send_destination_request.py -f barista -r barista_1 -x 10.142500 -y -7.412360 --yaw 0.0 -i 1
ros2 run ff_examples_ros2 send_destination_request.py -f barista -r barista_2 -x 10.246500 -y -11.054800 --yaw 0.0 -i 2

ros2 run ff_examples_ros2 send_destination_request.py -f barista -r barista_1 -x 11.502300 -y -9.180780 --yaw 0.0 -i 3

# Path sending ( always change the ID, because it ha sto be unique)
ros2 run ff_examples_ros2 send_path_request.py -f barista -r barista_1 -i 5 -p '[{"x": 10.142500, "y": -7.412360, "yaw": 0.0, "level_name": "B1"}, {"x": 11.502300, "y": -9.180780, "yaw": 0.0, "level_name": "B1"}, {"x": 10.246500, "y": -11.054800, "yaw": 3.14, "level_name": "B1"}]'
ros2 run ff_examples_ros2 send_path_request.py -f barista -r barista_2 -i 6 -p '[{"x": 10.142500, "y": -7.412360, "yaw": 0.0, "level_name": "B1"}, {"x": 11.502300, "y": -9.180780, "yaw": 0.0, "level_name": "B1"}, {"x": 10.246500, "y": -11.054800, "yaw": 3.14, "level_name": "B1"}]'



# Pause and resume ( always change the ID, because it ha sto be unique)
ros2 run ff_examples_ros2 send_mode_request.py -f barista -r barista_1 -m pause -i 8
ros2 run ff_examples_ros2 send_mode_request.py -f barista -r barista_1 -m resume -i 9

# Start the RMS system

source install/setup.bash;reset;ros2 launch barista_rmf_gazebo start_rmf_multirobot_turtlebotworld.launch.xml

# Edit TRaffic map
traffic-editor

# RMF monitor web
https://open-rmf.github.io/rmf-panel-js/