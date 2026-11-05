# Hand-on 01: TurtleBot4 simulator setup

This hand-on builds the shared TurtleBot4 course image, then lets each student choose the simulator view that suits their computer:

- **GUI:** Gazebo GUI + RViz2. Choose this when you need to inspect or edit Gazebo world entities.
- **Headless:** Gazebo server + RViz2. Choose this on machines that struggle with Gazebo's full GUI. RViz2 still shows the robot, map, lidar, camera, and TF, and provides Nav2 goal controls. Gazebo world editing is not available in this mode.

Both options use the same image and ROS configuration. Run one simulator mode at a time.

## Requirements

- Ubuntu 22.04 recommended, with Docker Engine installed and usable by your account.
- An active X11 desktop session (`DISPLAY` must be set) for RViz2.
- `/dev/dri` devices for sensor rendering. NVIDIA passthrough is enabled automatically when `nvidia-smi` is available; otherwise Docker uses the host's available DRI device.
- Several GB of free disk space for Docker layers and the image.

## 1. Build the course image

Run from this folder:

```bash
./scripts/ubuntu/1build_docker_x11.sh
```

The script also works when invoked by its absolute or relative path from another directory. It builds and tags `turtlebot4:x11`. The first build can take a while as Docker downloads ROS, Gazebo, and course dependencies.

## 2. Choose a simulator mode

For Gazebo GUI + RViz2:

```bash
./scripts/ubuntu/2bringup_docker_gui.sh
```

For headless Gazebo + RViz2:

```bash
./scripts/ubuntu/2.1bringup_docker_headless.sh
```

Optional ROS launch arguments can follow either command, for example:

```bash
./scripts/ubuntu/2.1bringup_docker_headless.sh world:=maze slam:=true nav2:=true
```

By default, the launch starts the maze, standard TurtleBot4, SLAM, Nav2, and RViz2. In RViz2, use the Navigation panel to set an initial pose and send navigation goals. Direct Gazebo world/entity editing remains a GUI-mode task.

## Contents

- `scripts/ubuntu/1build_docker_x11.sh` builds the shared image.
- `scripts/ubuntu/2bringup_docker_gui.sh` launches Gazebo GUI + RViz2.
- `scripts/ubuntu/2.1bringup_docker_headless.sh` launches headless Gazebo + RViz2.
- `scripts/ubuntu/_run_simulator.sh` contains the common container/display setup.
- `Dockerfile.x11`, `course_simulator.launch.py`, `robot.rviz`, and the maze, robot-description, and RViz assets make this hand-on self-contained.

Later hand-ons will be added as separate folders under `hand-ons/`.
