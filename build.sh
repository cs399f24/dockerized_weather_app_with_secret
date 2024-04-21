#!/bin/bash

# if collector/collector.env does not exist, error out
if [ ! -f collector/collector.env ]; then
  echo "collector/collector.env does not exist. Exiting."
  exit 1
fi

if [ ! -f server/server.env ]; then
  echo "server/server.env does not exist. Exiting."
  exit 1
fi

if ! docker image inspect collector > /dev/null 2>&1; then
  docker build -t collector collector
fi

if ! docker image inspect server > /dev/null 2>&1; then
  docker build -t server server
fi

if ! docker network inspect weather > /dev/null 2>&1; then
  docker network create weather
fi
