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
