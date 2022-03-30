import launch
from launch.substitutions import Command, LaunchConfiguration, FindExecutable, PathJoinSubstitution
import launch_ros
import os

from launch_ros.substitutions import FindPackageShare

def generate_launch_description():

    robot_description_content = Command(
        [
            PathJoinSubstitution([FindExecutable(name="xacro")]),
            " ",
            PathJoinSubstitution(
                [FindPackageShare("barista_description"), "src", "description", "barista_hexagons_asus_xtion_pro.urdf"]
            ),
        ]
    )

    robot_description = {"robot_description": robot_description_content}

    pkg_share = launch_ros.substitutions.FindPackageShare(package='barista_description').find('barista_description')
    default_model_path = os.path.join(pkg_share, 'src/description/barista_hexagons_asus_xtion_pro.urdf')
    # default_rviz_config_path = os.path.join(pkg_share, 'rviz/diffbot.rviz')
    default_ros2_control_config_path = os.path.join(pkg_share, 'config/rb1_controller.yaml')

    # control_node = launch_ros.actions.Node(
    #     package="controller_manager",
    #     executable="ros2_control_node",
    #     parameters=[robot_description, default_ros2_control_config_path],
    #     output={
    #         "stdout": "screen",
    #         "stderr": "screen",
    #     },
    # )

    # joint_state_broadcaster_spawner = launch_ros.actions.Node(
    #     package="controller_manager",
    #     executable="spawner.py",
    #     arguments=["joint_state_broadcaster", "--controller-manager", "/controller_manager"],
    # )

    # robot_controller_spawner = launch_ros.actions.Node(
    #     package="controller_manager",
    #     executable="spawner.py",
    #     arguments=["rb1_base_controller", "-c", "/controller_manager"],
    # )


    robot_state_publisher_node = launch_ros.actions.Node(
        package='robot_state_publisher',
        executable='robot_state_publisher',
        parameters=[{'robot_description': Command(['xacro ', LaunchConfiguration('model')])}],
        # remappings=[
        #     ("/rb1_base_controller/cmd_vel_unstamped", "/cmd_vel"),
        # ],
    )
    joint_state_publisher_node = launch_ros.actions.Node(
        package='joint_state_publisher',
        executable='joint_state_publisher',
        name='joint_state_publisher',
        # condition=launch.conditions.UnlessCondition(LaunchConfiguration('gui'))
    )

    # rviz_node = launch_ros.actions.Node(
    #     package='rviz2',
    #     executable='rviz2',
    #     name='rviz2',
    #     output='screen',
    #     arguments=['-d', LaunchConfiguration('rvizconfig')],
    # )
    spawn_entity = launch_ros.actions.Node(
        package='gazebo_ros',
        executable='spawn_entity.py',
        arguments=['-entity', 'barista', '-topic', 'robot_description'],
        output='screen'
    )

    return launch.LaunchDescription([
        launch.actions.DeclareLaunchArgument(name='gui', default_value='True',
                                            description='Flag to enable joint_state_publisher_gui'),
        launch.actions.DeclareLaunchArgument(name='model', default_value=default_model_path,
                                            description='Absolute path to robot urdf file'),
        # launch.actions.DeclareLaunchArgument(name='rvizconfig', default_value=default_rviz_config_path,
        #                                     description='Absolute path to rviz config file'),
        launch.actions.ExecuteProcess(cmd=['gazebo', '--verbose', '-s', 'libgazebo_ros_init.so', '-s', 'libgazebo_ros_factory.so'], output='screen'),
        spawn_entity,
        joint_state_publisher_node,
        robot_state_publisher_node,
        # control_node,
        # joint_state_broadcaster_spawner,
        # robot_controller_spawner,
        # rviz_node
    ])