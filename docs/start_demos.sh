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



/home/tgrip/TheConstruct/ros_2_playground/ff_ros2_ws/build/barista_rmf_gazebo/maps/tc_coffeeshop/tc_coffeeshop.world


#################
# DEMO of Real environment
#################

#Steps to follow:

# Create a map of the env with navigation
# STep2: Create with traffic, the yaml file with the image map as refference and 
# Step3: build the world for gazebo automatically an dtest it
# Step4: Create a new gazebo launch that spawns the robots insid ethis new environment, ( we get the poses from the traffic-editor points with the scale already placed)


# Step5: Create a new navigation launch that uses new yaml config files that use the new map
# Normally the map yaml of the navigation is displaced from the simulation. So we change teh orogin of the yaml of the map until it matches
# Us ethe grid in RVIZ to mesure the displacement you might have
# The initial pose of the robots has to be changed to the one in the spawn simulation

# Step6: Create new RMF launch file that launches with the yaml file of the new map build.yaml
# We have to add here in the building.yaml the new baristas in teh list and the number iof them in the ...building.yaml
# We have to also create teh dashboard folder insid ethe dashboard_config in the barista_rmf_gazebo, for the new build.yaml. Has to have same name as the build.yaml file
# Inside it add the new node places in the dashboard_config.json. This is used by the web client
# Create also the rviz file with the same name.


# Step7: Check that RMF works in this new environment


colcon build --packages-select barista_ros2_ff barista_ros2_navigation nav2_bringup barista_rmf_gazebo

source install/setup.bash;reset;ros2 launch barista_ros2_ff start_world_standalone_tc_coffee_shop.launch.py
source install/setup.bash;reset;ros2 launch barista_ros2_ff multi_barista_tc_coffee_shop.launch.py
source install/setup.bash;reset;ros2 launch barista_ros2_ff start_barista_navigation_tc_coffee_shop.launch.xml

# Launch everything sim and navigation and client server of ff

source install/setup.bash;reset;ros2 launch barista_ros2_ff main_multiple_robots_tc_coffee_shop.launch.xml
# Test FF client server is working, you can generate these points by placing a simple cube in teh scene in sim and check the position
ros2 run ff_examples_ros2 send_destination_request.py -f barista -r barista_1 -x 101.974000 -y -97.028000 --yaw 0.0 -i 1
ros2 run ff_examples_ros2 send_destination_request.py -f barista -r barista_2 -x 98.690100 -y -97.033900 --yaw 0.0 -i 2

# Test the RMF
source install/setup.bash;reset;ros2 launch barista_rmf_gazebo start_rmf_multirobot_tc_caffee_shop_world.launch.xml

# RMF monitor web
https://open-rmf.github.io/rmf-panel-js/