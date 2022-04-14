#!/usr/bin/python3
# -*- coding: utf-8 -*-

from launch.launch_description_sources import PythonLaunchDescriptionSource
from ament_index_python.packages import get_package_share_directory
from ament_index_python.packages import get_package_prefix
from launch.actions import IncludeLaunchDescription
from launch.actions import DeclareLaunchArgument
from launch import LaunchDescription
import os

def generate_launch_description():

    pkg_gazebo_ros = get_package_share_directory('gazebo_ros')
    my_package_name = "barista_description"
    pkg_barista_gazebo = get_package_share_directory(my_package_name)
    install_dir = get_package_prefix(my_package_name)

    gazebo_plugins_name = "gazebo_plugins"
    gazebo_plugins_name_path_install_dir = get_package_prefix(gazebo_plugins_name)

    plugin_pkg = "rmf_robot_sim_gazebo_plugins"
    plugin_dir = get_package_prefix(plugin_pkg)



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
        os.environ['GAZEBO_PLUGIN_PATH'] = install_dir + '/lib' + ':' + plugin_dir + '/lib' + '/rmf_robot_sim_gazebo_plugins'

    

    print("GAZEBO MODELS PATH=="+str(os.environ["GAZEBO_MODEL_PATH"]))
    print("GAZEBO PLUGINS PATH=="+str(os.environ["GAZEBO_PLUGIN_PATH"]))

    # Gazebo launch
    gazebo = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(
            os.path.join(pkg_gazebo_ros, 'launch', 'gazebo.launch.py'),
        )
    )    

    # path_to_world = os.path.join(pkg_barista_gazebo, 'worlds', 'tc_coffeeshop.world')

    pkg_rmf_tc = get_package_share_directory("rmf_tc")
    path_to_world = os.path.join(pkg_rmf_tc, 'maps','simple', 'bob.world')

    return LaunchDescription([
        DeclareLaunchArgument(
          'world',
          default_value=[path_to_world, ''],
          description='SDF world file'),
        gazebo
    ])