#!/bin/bash
#docker network create mybridge --subnet=172.1.0.0/16
docker stop p1 && docker rm p1

# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
dir=$(pwd)
echo "当前目录：$dir"
docker run --name p1 \
  --restart=always \
  --network=mybridge --ip=172.1.1.11 \
  -v "$dir/php7/etc":/usr/local/php/etc \
  -v /etc/localtime:/etc/localtime:ro \
  -itd cffycls/php
#	-v /home/wwwroot/cluster/html:/var/www/html \