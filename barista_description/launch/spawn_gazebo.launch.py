from launch.launch_description_sources import PythonLaunchDescriptionSource
from ament_index_python.packages import get_package_share_directory
from launch.substitutions import Command, LaunchConfiguration
from ament_index_python.packages import get_package_prefix
from launch.actions import IncludeLaunchDescription
from launch.actions import DeclareLaunchArgument
import launch_ros
import launch
import os

def generate_launch_description():

    pkg_share = launch_ros.substitutions.FindPackageShare(package='barista_description').find('barista_description')
    default_model_path = os.path.join(pkg_share, 'src/description/barista.sdf')
    default_urdf_model_path = os.path.join(pkg_share, 'src/description/barista.urdf')

    pkg_gazebo_ros = get_package_share_directory('gazebo_ros')
    my_package_name = "barista_description"
    pkg_barista_gazebo = get_package_share_directory(my_package_name)
    install_dir = get_package_prefix(my_package_name)

    gazebo_plugins_name = "gazebo_plugins"
    gazebo_plugins_name_path_install_dir = get_package_prefix(gazebo_plugins_name)

    # Set the path to the WORLD model files. Is to find the models inside the models folder in uniclicle_robot_pkg package
    gazebo_models_path = os.path.join(pkg_barista_gazebo, 'models')
    # os.environ["GAZEBO_MODEL_PATH"] = gazebo_models_path

    if 'GAZEBO_MODEL_PATH' in os.environ:
        os.environ['GAZEBO_MODEL_PATH'] =  os.environ['GAZEBO_MODEL_PATH'] + ':' + install_dir + '/share' + ':' + gazebo_models_path
    else:
        os.environ['GAZEBO_MODEL_PATH'] =  install_dir + "/share" + ':' + gazebo_models_path

    if 'GAZEBO_PLUGIN_PATH' in os.environ:
        os.environ['GAZEBO_PLUGIN_PATH'] = os.environ['GAZEBO_PLUGIN_PATH'] + ':' + install_dir + '/lib' + ':' + gazebo_plugins_name_path_install_dir + '/lib' 
    else:
        os.environ['GAZEBO_PLUGIN_PATH'] = install_dir + '/lib' + ':' + gazebo_plugins_name_path_install_dir + '/lib' + '/rmf_robot_sim_gazebo_plugins'

    

    print("GAZEBO MODELS PATH=="+str(os.environ["GAZEBO_MODEL_PATH"]))
    print("GAZEBO PLUGINS PATH=="+str(os.environ["GAZEBO_PLUGIN_PATH"]))



    robot_state_publisher_node = launch_ros.actions.Node(
        package='robot_state_publisher',
        executable='robot_state_publisher',
        parameters=[{'robot_description': Command(['xacro ', LaunchConfiguration('urdf_model')])}],
    )

    joint_state_publisher_node = launch_ros.actions.Node(
        package='joint_state_publisher',
        executable='joint_state_publisher',
        name='joint_state_publisher',
    )

    # Gazebo launch
    gazebo = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(
            os.path.join(pkg_gazebo_ros, 'launch', 'gazebo.launch.py'),
        )
    )    


    spawn_entity = launch_ros.actions.Node(
        package='gazebo_ros',
        executable='spawn_entity.py',
        # arguments=['-entity', 'barista', '-topic', 'robot_description', '-x 0', '-y 0', '-z 0', '-Y 1.57'],
        arguments=['-entity', 'barista', '-file', default_model_path, '-x 0', '-y 0', '-z 0', '-Y 1.57'],
        output='screen'
    )

    return launch.LaunchDescription([

        DeclareLaunchArgument(
          'world',
          default_value=[os.path.join(pkg_barista_gazebo, 'worlds', 'tc_coffeeshop.world'), ''],
          description='SDF world file'),

        launch.actions.DeclareLaunchArgument(name='model', default_value=default_model_path,
                                            description='Absolute path to robot urdf file'),

        launch.actions.DeclareLaunchArgument(name='urdf_model', default_value=default_urdf_model_path,
                                            description='Absolute path to robot urdf file'),
        
        # launch.actions.ExecuteProcess(cmd=['gazebo', '--verbose', '-s', 'libgazebo_ros_init.so', '-s', 'libgazebo_ros_factory.so'], output='screen'),

        gazebo,
        spawn_entity,
        joint_state_publisher_node,
        robot_state_publisher_node,
    ])