#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HANDON_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

if ! docker info >/dev/null 2>&1; then
  echo "Docker Desktop is not running or Docker is unavailable." >&2
  exit 1
fi

printf 'Building the shared TurtleBot4 image...\n'
docker build -f "$HANDON_DIR/Dockerfile.x11" -t turtlebot4:x11 "$HANDON_DIR"
printf '\nBuilding the MacOS VNC image...\n'
docker build -f "$HANDON_DIR/Dockerfile.vnc" -t turtlebot4:vnc "$HANDON_DIR"
printf '\nBuild complete: turtlebot4:vnc\n'
printf 'Next, choose the Gazebo GUI or headless + RViz2 option.\n'
