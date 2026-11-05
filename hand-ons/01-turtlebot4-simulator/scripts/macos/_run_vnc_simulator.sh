#!/usr/bin/env bash
set -euo pipefail

MODE="${1:?Internal use: pass gui or headless}"
shift
case "$MODE" in
  gui|headless) ;;
  *) echo "Unknown mode: $MODE (use gui or headless)" >&2; exit 2 ;;
esac

IMAGE="${TURTLEBOT4_VNC_IMAGE:-turtlebot4:vnc}"
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
  echo "Docker image $IMAGE is missing. Run 1build_docker_vnc.sh first." >&2
  exit 1
fi

exec docker run --rm -it \
  --name turtlebot4_sim \
  -p 127.0.0.1:5900:5900 \
  -e VNC_GEOMETRY="${VNC_GEOMETRY:-1920x1080}" \
  "$IMAGE" \
  /usr/local/bin/start_vnc_simulator.sh "$MODE" "$@"
