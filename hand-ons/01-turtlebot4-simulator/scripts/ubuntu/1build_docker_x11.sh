#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
HANDON_DIR="$(cd -- "$SCRIPT_DIR/../.." && pwd)"
IMAGE="${TURTLEBOT4_IMAGE:-turtlebot4:x11}"

printf 'Building %s from %s\n' "$IMAGE" "$HANDON_DIR"
docker build -f "$HANDON_DIR/Dockerfile.x11" -t "$IMAGE" "$HANDON_DIR"
printf '\nBuild complete: %s\n' "$IMAGE"
printf 'Next, choose one simulator mode:\n'
printf '  %s\n' "$HANDON_DIR/scripts/ubuntu/2bringup_docker_gui.sh"
printf '  %s\n' "$HANDON_DIR/scripts/ubuntu/2.1bringup_docker_headless.sh"
