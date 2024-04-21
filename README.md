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


## AWS Deploy

To deploy on AWS, we have to do following:

1. Install `git` and clone the repository

  ```
  sudo yum install -y git
  git clone https://github.com/cs220s24/dockerized_weather_app.git
  ```
  
2. Install docker, start it, and make it available to the `ec2-user`.  All steps are embedded in `aws_deploy.sh`

  ```
  cd dockerized_weather_app
  ./aws_deploy.sh
  ```
  
  NOTE:  After this step you need to log out and log back in to the EC2 instance.  The last step in the script is to add the `ec2-user` to the `docker` group so it can run `docker` commands, but the shell only reads group membership at login.
  
3.  We will mount `collector.env` as `.env` in the `collector` container and `server.env` as `.env` in the `server` container.  Make those files:

  Create `colector/collector.env` as:

  ```
  REDIS_HOST=redisdb
  REDIS_PORT=6379
  API_KEY=<api key>
  ```

  Create `server/server.env` as:

  ```
  REDIS_HOST=redisdb
  REDIS_PORT=6379
  ```
  
4. Build the container images.  These steps are embedded in `build.sh`

  ```
  ./build.sh
  ```
  
5. Launch the system.  There are three containers to start (`redis`, `collector`, and `server`), and all three need to be started in the same Docker network.  In addition, the `redis` container needs to mount a volume to ensure the `dump.rdb` file is saved, and the `collector` and `server` containers need to have their `.env` files mounted.  The `up` script contains all the necessary commands

  ```
  ./up
  ```


## Validation

If everything worked, you will be able to get the current temperature in Bethlehem by accessing the system.

  ```
  curl localhost
  ```
  
If this works, you can verify that your EC2 instance is configured correctly by connecting to the system using a web browser

  ```
  http://<EC2 IP address>
  ```
  
## Stop the System
  
  
If you need to stop the system, use the `down` script:
  
  ```
  ./down
  ```  
  
  
