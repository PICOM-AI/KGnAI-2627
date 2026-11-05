#!/usr/bin/env bash
set -euo pipefail

MODE="${1:?Internal use: pass gui or headless}"
shift
case "$MODE" in
  gui) HEADLESS=false ;;
  headless) HEADLESS=true ;;
  *) echo "Unknown mode: $MODE (use gui or headless)" >&2; exit 2 ;;
esac

IMAGE="${TURTLEBOT4_IMAGE:-turtlebot4:x11}"
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
  echo "Docker image $IMAGE is missing. Run 1build_docker_x11.sh first." >&2
  exit 1
fi
if [[ -z "${DISPLAY:-}" ]]; then
  echo "DISPLAY is unset. An X11 desktop session is required for RViz2." >&2
  exit 1
fi
if [[ ! -d /dev/dri ]]; then
  echo "No /dev/dri devices found. Sensor rendering may fail." >&2
  exit 1
fi

GPU_ARGS=()
GPU_ENV_ARGS=()
if command -v nvidia-smi >/dev/null 2>&1 && nvidia-smi >/dev/null 2>&1; then
  GPU_ARGS+=(--gpus all)
  GPU_ENV_ARGS+=(
    -e __NV_PRIME_RENDER_OFFLOAD=1
    -e __GLX_VENDOR_LIBRARY_NAME=nvidia
    -e NVIDIA_DRIVER_CAPABILITIES=graphics,utility,compute
  )
fi

xhost +local:docker >/dev/null
trap 'xhost -local:docker >/dev/null 2>&1 || true' EXIT

docker run --rm -it \
  "${GPU_ARGS[@]}" \
  --ipc host \
  --name turtlebot4_sim \
  -e DISPLAY="$DISPLAY" \
  -e QT_X11_NO_MITSHM=1 \
  "${GPU_ENV_ARGS[@]}" \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  --device /dev/dri \
  "$IMAGE" \
  ros2 launch turtlebot4_ignition_bringup course_simulator.launch.py \
    world:=maze model:=standard headless:="$HEADLESS" rviz:=true slam:=true nav2:=true "$@"
