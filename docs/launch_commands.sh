# Shell ONE
source /home/tgrip/TheConstruct/ros_2_playground/coffee_shop_ws/install/setup.bash
export GAZEBO_PLUGIN_PATH=/usr/lib/x86_64-linux-gnu/gazebo-11/plugins:/usr/lib/x86_64-linux-gnu/gazebo-11/plugins:/home/tgrip/TheConstruct/ros_2_playground/coffee_shop_ws/install/barista_description/lib:/opt/ros/galactic/lib:/home/tgrip/TheConstruct/ros_2_playground/coffee_shop_ws/install/rmf_robot_sim_gazebo_plugins/lib/rmf_robot_sim_gazebo_plugins
ros2 launch barista_description multi_barista.launch.py
ros2 launch barista_description one_barista.launch.py

# Shell TWO
source /home/tgrip/TheConstruct/ros_2_playground/coffee_shop_ws/install/setup.bash
export GAZEBO_PLUGIN_PATH=/usr/lib/x86_64-linux-gnu/gazebo-11/plugins:/usr/lib/x86_64-linux-gnu/gazebo-11/plugins:/home/tgrip/TheConstruct/ros_2_playground/coffee_shop_ws/install/barista_description/lib:/opt/ros/galactic/lib:/home/tgrip/TheConstruct/ros_2_playground/coffee_shop_ws/install/rmf_robot_sim_gazebo_plugins/lib/rmf_robot_sim_gazebo_plugins
ros2 launch rmf_tc rmf_tc_coffeeshop.launch.xml
ros2 launch rmf_tc rmf_tc_coffeeshop_one_barista.launch.xml



# DEMO LAUNCHES
source /home/tgrip/TheConstruct/ros_2_playground/coffee_shop_ws/install/setup.bash
export GAZEBO_PLUGIN_PATH=/usr/lib/x86_64-linux-gnu/gazebo-11/plugins:/usr/lib/x86_64-linux-gnu/gazebo-11/plugins:/home/tgrip/TheConstruct/ros_2_playground/coffee_shop_ws/install/barista_description/lib:/opt/ros/galactic/lib:/home/tgrip/TheConstruct/ros_2_playground/coffee_shop_ws/install/rmf_robot_sim_gazebo_plugins/lib/rmf_robot_sim_gazebo_plugins
ros2 launch rmf_demos_gz hotel.launch.xml




export GAZEBO_MODEL_PATH=/home/tgrip/TheConstruct/ros_2_playground/coffee_shop_ws/build/rmf_tc/maps/simple/models

################
# EDIT COMMANDS
################

colcon build --packages-select barista_rmf_gazebo

traffic-editor


#############################
# DEBUGGING TESTS
#############################
# We launch only the simulation ( generated in build time using teh rmf_config/simple1_big.building.yaml)
ros2 launch barista_rmf_gazebo main.launch.xml

# >>>> Sale esto:
# [slotcar_barista_1]: Unable to determine the current level_name for robot [barista_1].
# Kindly ensure the building_map_server is running. 
# The RobotState message for this robot will not be published.

ros2 launch barista_rmf_gazebo start_rmf.launch.xml


################
# Tests to rebbot whats going on
################

ros2 launch rmf_demos_gz hotel_tests.launch.xml