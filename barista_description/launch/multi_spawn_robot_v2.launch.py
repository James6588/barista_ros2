#!/usr/bin/python3
# -*- coding: utf-8 -*-
import os

from ament_index_python.packages import get_package_share_directory, get_package_prefix
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.substitutions import LaunchConfiguration, TextSubstitution
from launch.actions import IncludeLaunchDescription
from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument
from launch.actions import OpaqueFunction


def gen_robot_list(number_of_robots):

    robots = []

    for i in range(number_of_robots):
        robot_name = "barista"+str(i)
        x_pos = float(i)
        if i == 0:
            robots.append({'name': robot_name, 'x_pose': -3.005785, 'y_pose': 4.017705, 'z_pose': 0.01, 'Y_pose': 0.0})
        else:
            robots.append({'name': robot_name, 'x_pose': x_pos, 'y_pose': 0.0, 'z_pose': 0.01, 'Y_pose': 1.4})


    return robots 

def launch_setup(context, *args, **kwargs):
    ####### DATA INPUT ##########
    # This is to access the argument variables. Otherwise we cant access the values
    number_of_robots = LaunchConfiguration('number_of_robots').perform(context)
    
    urdf = os.path.join(get_package_share_directory('barista_description'), 'src/', 'description/', 'barista.urdf')
    sdf = os.path.join(get_package_share_directory('barista_description'), 'src/', 'description/', 'barista.sdf')

    pkg_barista_description = get_package_share_directory('barista_description')
    assert os.path.exists(urdf), "The barista_bot.urdf doesn't exist in "+str(urdf)

    # Names and poses of the robots
    robots = gen_robot_list(int(number_of_robots))

    # We create the list of spawn robots commands
    spawn_robots_cmds = []
    for robot in robots:
        spawn_robots_cmds.append(
            IncludeLaunchDescription(
                PythonLaunchDescriptionSource(os.path.join(pkg_barista_description, 'launch',
                                                           'spawn_barista.launch.py')),
                launch_arguments={
                                  'robot_urdf': sdf,
                                  'x': TextSubstitution(text=str(robot['x_pose'])),
                                  'y': TextSubstitution(text=str(robot['y_pose'])),
                                  'z': TextSubstitution(text=str(robot['z_pose'])),
                                  'Y': TextSubstitution(text=str(robot['Y_pose'])),
                                  'robot_name': robot['name'],
                                  'robot_namespace': robot['name']
                                  }.items()))

    # Create the launch description and populate
    ld = LaunchDescription()

    launch_list = []
    
    for spawn_robot_cmd in spawn_robots_cmds:
        launch_list.append(spawn_robot_cmd)


    return launch_list

def generate_launch_description(): 

    number_of_robots_arg = DeclareLaunchArgument('number_of_robots', default_value='2')
    

    return LaunchDescription([
        number_of_robots_arg,
        OpaqueFunction(function = launch_setup)
        ])