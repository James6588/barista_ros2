# Commands to create packages

ros2 pkg create --build-type ament_cmake barista_rmf_gazebo --dependencies rclcpp rclpy gazebo_ros 
mkdir barista_rmf_gazebo/launch
touch barista_rmf_gazebo/launch/main.launch.xml
touch barista_rmf_gazebo/launch/simulation.launch.xml

# Here we will store the map configurations
mkdir barista_rmf_gazebo/rmf_config

colcon build --packages-select barista_rmf_gazebo

traffic-editor

# We add the ap generation and path generation

