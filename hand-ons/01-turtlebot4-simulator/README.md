# Hand-on 01: TurtleBot4 simulator setup

This hand-on builds the shared TurtleBot4 course image, then lets each student choose the simulator view that suits their computer:

- **GUI:** Gazebo GUI + RViz2. Choose this when you need to inspect or edit Gazebo world entities.
- **Headless:** Gazebo server + RViz2. Choose this on machines that struggle with Gazebo's full GUI. RViz2 still shows the robot, map, lidar, camera, and TF, and provides Nav2 goal controls. Gazebo world editing is not available in this mode.

Both options use the same image and ROS configuration. Run one simulator mode at a time.

## Requirements

### Ubuntu

- Ubuntu 22.04 recommended, with Docker Engine installed and usable by your account.
- An active X11 desktop session (`DISPLAY` must be set) for RViz2.
- `/dev/dri` devices for sensor rendering. NVIDIA passthrough is enabled automatically when `nvidia-smi` is available; otherwise Docker uses the host's available DRI device.

### macOS

- Docker Desktop installed and running.
- A VNC viewer such as RealVNC Viewer or TigerVNC Viewer.
- Several GB of free disk space for Docker layers and the image.

The macOS scripts follow the repository's established VNC-in-container setup; both simulator modes use the same VNC desktop. They publish VNC on `127.0.0.1:5900` without a password, so connect from the same Mac and do not expose that port to a network.

## Ubuntu setup

Build the course image:

```bash
./scripts/ubuntu/1build_docker_x11.sh
```

The script works when invoked from this folder or by its path from another directory. It builds and tags `turtlebot4:x11`.

Choose one simulator mode:

```bash
# Gazebo GUI + RViz2
./scripts/ubuntu/2bringup_docker_gui.sh

# Headless Gazebo + RViz2
./scripts/ubuntu/2.1bringup_docker_headless.sh
```

## macOS setup

Build the shared simulator image and the VNC-enabled image:

```bash
./scripts/macos/1build_docker_vnc.sh
```

Choose one simulator mode:

```bash
# Gazebo GUI + RViz2, displayed through VNC
./scripts/macos/2bringup_docker_vnc.sh

# Headless Gazebo + RViz2, displayed through VNC
./scripts/macos/2.1bringup_docker_vnc_headless.sh
```

After the VNC script starts, connect the viewer to `127.0.0.1:5900`. Press `Ctrl+C` in Terminal to stop the simulator.

## Using the simulator

Both platforms start the maze, standard TurtleBot4, SLAM, Nav2, and RViz2. In RViz2, use the Navigation panel to set an initial pose and send navigation goals. Headless mode hides Gazebo's 3D window but keeps the ROS sensors and RViz2 available. Direct Gazebo world/entity editing requires GUI mode.

Optional ROS launch arguments can follow a bringup command, for example:

```bash
./scripts/ubuntu/2.1bringup_docker_headless.sh world:=maze slam:=true nav2:=true
```

## Contents

- `scripts/ubuntu/1build_docker_x11.sh` builds the shared image.
- `scripts/ubuntu/2bringup_docker_gui.sh` launches Gazebo GUI + RViz2.
- `scripts/ubuntu/2.1bringup_docker_headless.sh` launches headless Gazebo + RViz2.
- `scripts/ubuntu/_run_simulator.sh` contains the common container/display setup.
- `scripts/macos/` provides the matching VNC-based build and both simulator modes.
- `scripts/container/start_vnc_simulator.sh` starts the VNC desktop and course launch inside the container.
- `Dockerfile.x11`, `Dockerfile.vnc`, `launch/`, `config/`, and `assets/` make this hand-on self-contained.

Later hand-ons will be added as separate folders under `hand-ons/`.
