#!/bin/bash
install -y git
git clone https://github.com/cs399s24/dockerized_weather_app_with_secret.git 
yum install -y docker
systemctl enable docker
systemctl start docker
echo "REDIS_HOST=redisdb" >> dockerized_weather_app_with_secret/collector/collector.env
echo "REDIS_PORT=6379" >> dockerized_weather_app_with_secret/collector/collector.env
echo "REDIS_HOST=redisdb" >> dockerized_weather_app_with_secret/server/server.env
echo "REDIS_PORT=6379" >> dockerized_weather_app_with_secret/server/server.env
docker build -t collector dockerized_weather_app_with_secret/collector
docker build -t server dockerized_weather_app_with_secret/server
docker network create weather
docker run -d --network weather --name redisdb -p 6379:6379 -v $(pwd)/dockerized_weather_app_with_secret/data:/data redis redis-server --save 10 1
docker run -d --network weather --name collector -v $(pwd)/dockerized_weather_app_with_secret/collector/collector.env:/app/.env collector
docker run -d --network weather --name server -p 80:80 -v $(pwd)/dockerized_weather_app_with_secret/server/server.env:/app/.env server
