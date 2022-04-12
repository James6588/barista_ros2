#!/usr/bin/python3
# -*- coding: utf-8 -*-
import os

from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch.actions import IncludeLaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource



def generate_launch_description():

    pkg_barista_description = get_package_share_directory('barista_description')

    # Sart World
    start_world = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(
            os.path.join(pkg_barista_description, 'launch', 'start_world.launch.py'),
        )
    )

    spawn_robot_world = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(
            os.path.join(pkg_barista_description, 'launch', 'multi_spawn_robot_v2.launch.py'),
        ),
        launch_arguments={
            "number_of_robots": "1"}.items()
    )     

    return LaunchDescription([
        start_world,
        spawn_robot_world
    ])