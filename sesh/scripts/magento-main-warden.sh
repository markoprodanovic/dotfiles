#!/usr/bin/env bash

# Ensures warden is running, then opens a shell.

if ! warden env ps 2>/dev/null | grep -q "Up"; then
  echo "Warden is down. Starting up..."
  warden svc up && warden env up
fi

warden shell
