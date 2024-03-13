## Overview

Our goal is to *Dockerize* the collector, redis server, and flask server of the weather app. We will:

* Create containers for the collector and server
* Develop commands to launch and destroy the redis, collector, and server containers
* Create scripts to launch and destroy the entire system

![architecture](architecture.png)

## Build a Container for the Collector

* Create a `Dockerfile`
* Build the Docker container and tag it with the name `weather_collector`

## Build a Container for the Server

* Create a `Dockerfile` (same basic pattern as the collector)
* Build the Docker container and tag it with the name `weather_server`

## Launch the System

* Create a network named `weather`
* Launch a Redis container 
  * Run the container in the `weatherweather` network
  * Name the container `redis`
* Launch an instance of the `weather_collector`
  * Run the container in the `weather` network
  * Name the container `weather_collector`
  * Create an environment variable named `REDIS_HOST` with the value `redis`
  * Create an environment variable named `REDIS_PORT` with the value 6379
* Launch an instance of the `weather_server`
  * Launch the container in the `weather` network
  * Name the container `weather_server`
  * Create an environment variable named `REDIS_HOST` with the value `redis`
  * Create an environment variable named `REDIS_PORT`
  * Expose port 8000

## Create a Launch Script

* In a file named `up`:
  * Launch the Redis container
  * Launch the collector container
  * Launch the server container
* In a file named `down`:
  * Stop (and remove) the server
  * Stop (and remove) the collector
  * Stop (and remove) the redis container
* Add executable permissions to both files
  * e.g. `chmod +x up`
* Run `./up` to start the system
* Run `/.down` to stop the system
