from launch.substitutions import Command, LaunchConfiguration, FindExecutable, PathJoinSubstitution
from launch_ros.substitutions import FindPackageShare
import launch_ros
import launch
import os
from ament_index_python.packages import get_package_share_directory

def generate_launch_description():

    robot_description_content = Command(
        [
            PathJoinSubstitution([FindExecutable(name="xacro")]),
            " ",
            PathJoinSubstitution(
                [FindPackageShare("barista_description"), "src", "description", "barista.urdf"]
            ),
        ]
    )

    robot_description = {"robot_description": robot_description_content}

    barista_description = get_package_share_directory('barista_description')
    pkg_share = launch_ros.substitutions.FindPackageShare(package='barista_description').find('barista_description')
    default_model_path = os.path.join(pkg_share, 'src/description/barista.urdf')


    robot_state_publisher_node = launch_ros.actions.Node(
        package='robot_state_publisher',
        executable='robot_state_publisher',
        parameters=[{'robot_description': Command(['xacro ', LaunchConfiguration('model')])}],

    )
    joint_state_publisher_node = launch_ros.actions.Node(
        package='joint_state_publisher',
        executable='joint_state_publisher',
        name='joint_state_publisher',
    )

    spawn_entity = launch_ros.actions.Node(
        package='gazebo_ros',
        executable='spawn_entity.py',
        arguments=['-entity', 'barista', '-topic', 'robot_description'],
        output='screen'
    )

    return launch.LaunchDescription([

        launch.actions.DeclareLaunchArgument('worlds',
            default_value=[os.path.join(barista_description, 'worlds', 'tc_coffeeshop.world'), ''],
            description='SDF world file',),

        launch.actions.DeclareLaunchArgument(name='gui', default_value='True',
                                            description='Flag to enable joint_state_publisher_gui'),
        launch.actions.DeclareLaunchArgument(name='model', default_value=default_model_path,
                                            description='Absolute path to robot urdf file'),
        

        launch.actions.ExecuteProcess(cmd=['gazebo', '--verbose', '-s', 'libgazebo_ros_init.so', '-s', 'libgazebo_ros_factory.so', 'worlds'], output='screen'),

        spawn_entity,
        joint_state_publisher_node,
        robot_state_publisher_node,

    ])