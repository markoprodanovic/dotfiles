#!/usr/bin/env bash

# Check if warden env is already up and running by looking for runing containers
if ! warden env ps 2>/dev/null | grep -q "Up"; then
  echo "Warden is down. Starting up..."
  warden svc up && warden env up
else
  echo "Warden is already running."
fi

warden shell
