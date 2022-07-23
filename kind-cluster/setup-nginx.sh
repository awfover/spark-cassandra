#!/usr/bin/env bash

id=$(docker ps -a -q --filter name=nginx --format="{{.ID}}")
if [ ! -z $id ]; then
    docker rm $(docker stop $id)
fi

ip=$(docker container inspect kind-0-control-plane --format '{{ .NetworkSettings.Networks.kind.IPAddress }}')

scp nginx/* $(cat ./MACHINE):/home/ubun/Programs/nginx

docker run --name nginx \
    --network kind \
    --add-host=history.spark.local:$ip \
    --add-host=spark.local:$ip \
    -d \
    -v /home/ubun/Programs/nginx/nginx.conf:/etc/nginx/nginx.conf \
    -v /home/ubun/Programs/nginx/default.conf:/etc/nginx/conf.d/default.conf \
    -p 80:80 \
    -p 10000:10000 \
    nginx



