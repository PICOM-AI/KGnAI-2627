# KGnAI 2026–2027 Hands-on Course

Welcome to the KGnAI course hands-on repository. Course material is released one hand-on at a time. Each hand-on folder contains its own instructions, scripts, configuration, and required assets.

## Hand-on index

| No. | Hand-on | Activities | Guide |
| --- | --- | --- | --- |
| 01 | TurtleBot4 simulator setup | Build the course image and choose Gazebo GUI or headless Gazebo with RViz2. | [Open hand-on 01](hand-ons/01-turtlebot4-simulator/README.md) |

## Quick links: hand-on 01

- **Ubuntu:** [build image](hand-ons/01-turtlebot4-simulator/scripts/ubuntu/1build_docker_x11.sh) · [Gazebo GUI](hand-ons/01-turtlebot4-simulator/scripts/ubuntu/2bringup_docker_gui.sh) · [headless + RViz2](hand-ons/01-turtlebot4-simulator/scripts/ubuntu/2.1bringup_docker_headless.sh)
- **macOS:** [build VNC images](hand-ons/01-turtlebot4-simulator/scripts/macos/1build_docker_vnc.sh) · [Gazebo GUI + VNC](hand-ons/01-turtlebot4-simulator/scripts/macos/2bringup_docker_vnc.sh) · [headless Gazebo + RViz2 + VNC](hand-ons/01-turtlebot4-simulator/scripts/macos/2.1bringup_docker_vnc_headless.sh)

Read the linked hand-on guide before running its scripts. It includes prerequisites, launch options, and troubleshooting notes.

## Repository structure

```text
hand-ons/
└── 01-turtlebot4-simulator/
    ├── README.md
    ├── Dockerfile.x11
    ├── Dockerfile.vnc
    ├── assets/
    ├── config/
    ├── launch/
    └── scripts/
        ├── ubuntu/
        ├── macos/
        └── container/
```

New hand-ons will appear in the index as they are released.
