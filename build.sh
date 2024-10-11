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

docker build -t collector collector
docker build -t server server
docker network create weather
