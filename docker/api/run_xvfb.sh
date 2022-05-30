#!/bin/bash

# Remove any outstanding Xvfb lock files
rm -f /tmp/.X99-lock

# Start Xvfb
echo "Starting Xvfb"
Xvfb ${DISPLAY} -screen 0 1024x768x24 -ac +render -noreset -nolisten tcp  &
Xvfb_pid="$!"
echo "Waiting for Xvfb (PID: $Xvfb_pid) to be ready..."
while ! xdpyinfo -display ${DISPLAY} > /dev/null 2>&1; do
    sleep 0.1
done
echo "Xvfb is running"

# Run passed-in command and capture exit value
$@

# Kill xvfb
while kill -0 $Xvfb_pid > /dev/null 2>&1; do
    wait
