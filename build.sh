#!/bin/bash

docker build -t collector collector
docker build -t server server
docker network create weather
