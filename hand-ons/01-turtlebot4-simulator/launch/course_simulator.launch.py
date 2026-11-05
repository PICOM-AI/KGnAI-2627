#!/usr/bin/env python3
"""TurtleBot4 Ignition server with sensor rendering and the RViz2 client."""

import os
from pathlib import Path

from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, IncludeLaunchDescription, OpaqueFunction, SetEnvironmentVariable
from launch.conditions import IfCondition
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.substitutions import LaunchConfiguration
from launch_ros.actions import Node


def generate_launch_description():
    tb4 = get_package_share_directory('turtlebot4_ignition_bringup')
    tb4_description = get_package_share_directory('turtlebot4_description')
    create_description = get_package_share_directory('irobot_create_description')
    create_bringup = get_package_share_directory('irobot_create_ignition_bringup')
    create_plugins = get_package_share_directory('irobot_create_ignition_plugins')
    ros_ign = get_package_share_directory('ros_ign_gazebo')

    resource_path = ':'.join([
        os.path.join(tb4, 'worlds'),
        '/workspace',
        os.path.join(create_bringup, 'worlds'),
        str(Path(tb4_description).parent.resolve()),
        str(Path(create_description).parent.resolve()),
    ])
    plugin_path = ':'.join([
        os.path.join(get_package_share_directory('turtlebot4_ignition_gui_plugins'), 'lib'),
        os.path.join(create_plugins, 'lib'),
    ])

    model = LaunchConfiguration('model')
    use_sim_time = LaunchConfiguration('use_sim_time')

    def launch_gazebo(context, *args, **kwargs):
        world_name = LaunchConfiguration('world').perform(context)
        model_name = LaunchConfiguration('model').perform(context)
        if LaunchConfiguration('headless').perform(context).lower() == 'true':
            gz_args = f'{world_name}.sdf -r -v 4 -s --headless-rendering'
        else:
            gui_config = os.path.join(tb4, 'gui', model_name, 'gui.config')
            gz_args = f'{world_name}.sdf -r -v 4 --gui-config {gui_config}'
        return [IncludeLaunchDescription(
            PythonLaunchDescriptionSource(os.path.join(ros_ign, 'launch', 'ign_gazebo.launch.py')),
            launch_arguments={'ign_args': gz_args, 'gz_args': gz_args}.items(),
        )]

    clock_bridge = Node(
        package='ros_gz_bridge', executable='parameter_bridge', name='clock_bridge',
        arguments=['/clock@rosgraph_msgs/msg/Clock[ignition.msgs.Clock'], output='screen',
    )
    navigation = get_package_share_directory('turtlebot4_navigation')
    localization = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(os.path.join(navigation, 'launch', 'localization.launch.py')),
        launch_arguments={
            'namespace': LaunchConfiguration('namespace'),
            'use_sim_time': use_sim_time,
            'map': LaunchConfiguration('map'),
        }.items(),
        condition=IfCondition(LaunchConfiguration('localization')),
    )

    robot = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(os.path.join(tb4, 'launch', 'turtlebot4_spawn.launch.py')),
        launch_arguments={
            'model': model,
            'use_sim_time': use_sim_time,
            'rviz': LaunchConfiguration('rviz'),
            'slam': LaunchConfiguration('slam'),
            'localization': 'false',
            'nav2': LaunchConfiguration('nav2'),
        }.items(),
    )

    return LaunchDescription([
        DeclareLaunchArgument('world', default_value='maze'),
        DeclareLaunchArgument('headless', default_value='true', choices=['true', 'false']),
        DeclareLaunchArgument('model', default_value='standard'),
        DeclareLaunchArgument('rviz', default_value='true', choices=['true', 'false']),
        DeclareLaunchArgument('slam', default_value='true', choices=['true', 'false']),
        DeclareLaunchArgument('localization', default_value='false', choices=['true', 'false']),
        DeclareLaunchArgument('map', default_value='/workspace/maze/maze.yaml'),
        DeclareLaunchArgument('namespace', default_value=''),
        DeclareLaunchArgument('nav2', default_value='true', choices=['true', 'false']),
        DeclareLaunchArgument('use_sim_time', default_value='true', choices=['true', 'false']),
        SetEnvironmentVariable('IGN_GAZEBO_RESOURCE_PATH', resource_path),
        SetEnvironmentVariable('IGN_GUI_PLUGIN_PATH', plugin_path),
        OpaqueFunction(function=launch_gazebo),
        clock_bridge,
        robot,
        localization,
    ])
