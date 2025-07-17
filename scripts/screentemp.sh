#!/bin/env zsh

PROGRAM_NAME="gammastep"

LOG_FILE="/tmp/toggle_program_debug.log" # Or a more permanent location like ~/.cache/regolith/toggle_program.log

exec > >(tee -a "$LOG_FILE") 2>&1

echo "\n--- Script run at $(date) ---"

PID=$(pgrep -x -o "$PROGRAM_NAME")

if [[ -n "$PID" ]]; then
  # Program is running, kill it
  echo "Found '$PROGRAM_NAME' running with PID: $PID. Killing process..."
  kill "$PID"
  if [[ $? -eq 0 ]]; then
    echo "'$PROGRAM_NAME' (PID $PID) killed successfully."
  else
    echo "Error: Failed to kill '$PROGRAM_NAME' (PID $PID)."
  fi
else
  nohup gammastep -O 3000 > /dev/null 2>&1 &
  NEW_PID=$(pgrep -x -o "$PROGRAM_NAME")
  if [[ -n "$NEW_PID" ]]; then
    echo "'$PROGRAM_NAME' started with PID: $NEW_PID."
  else
    echo "Error: Failed to start '$PROGRAM_NAME'. Check your PROGRAM_COMMAND."
  fi
fi
