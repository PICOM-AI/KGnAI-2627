#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-gui}"
shift || true
case "$MODE" in
  gui) HEADLESS=false ;;
  headless) HEADLESS=true ;;
  *) echo "Usage: start_vnc_simulator.sh [gui|headless] [launch arguments...]" >&2; exit 2 ;;
esac

export DISPLAY="${DISPLAY:-:0}"
VNC_GEOMETRY="${VNC_GEOMETRY:-1920x1080}"

Xvnc "$DISPLAY" \
  -geometry "$VNC_GEOMETRY" \
  -depth 24 \
  -localhost no \
  -SecurityTypes None \
  >/tmp/xvnc.log 2>&1 &

for _ in $(seq 1 30); do
  if xdpyinfo -display "$DISPLAY" >/dev/null 2>&1; then
    break
  fi
  sleep 1
done
if ! xdpyinfo -display "$DISPLAY" >/dev/null 2>&1; then
  cat /tmp/xvnc.log >&2
  echo "VNC display $DISPLAY did not start." >&2
  exit 1
fi

startxfce4 >/tmp/xfce.log 2>&1 &
sleep 3

exec ros2 launch turtlebot4_ignition_bringup course_simulator.launch.py \
  world:=maze model:=standard headless:="$HEADLESS" rviz:=true slam:=true nav2:=true "$@"
