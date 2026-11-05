# KGnAI 2026–2027 Hands-on Course

Welcome to the KGnAI course hands-on repository. Course material is released one hand-on at a time. Each hand-on folder contains its own instructions, scripts, configuration, and required assets.

## Hand-on index

| No. | Hand-on | Activities | Guide |
| --- | --- | --- | --- |
| 01 | TurtleBot4 simulator setup | Build the course image and choose Gazebo GUI or headless Gazebo with RViz2. | [Open hand-on 01](hand-ons/01-turtlebot4-simulator/README.md) |

## Quick links: hand-on 01

- [Build the TurtleBot4 Docker image](hand-ons/01-turtlebot4-simulator/scripts/ubuntu/1build_docker_x11.sh)
- [Launch Gazebo GUI with RViz2](hand-ons/01-turtlebot4-simulator/scripts/ubuntu/2bringup_docker_gui.sh)
- [Launch headless Gazebo with RViz2](hand-ons/01-turtlebot4-simulator/scripts/ubuntu/2.1bringup_docker_headless.sh)

Read the linked hand-on guide before running its scripts. It includes prerequisites, launch options, and troubleshooting notes.

## Repository structure

```text
hand-ons/
└── 01-turtlebot4-simulator/
    ├── README.md
    ├── Dockerfile.x11
    ├── assets/
    ├── config/
    ├── launch/
    └── scripts/ubuntu/
```

New hand-ons will appear in the index as they are released.
