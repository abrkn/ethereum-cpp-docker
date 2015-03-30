#!/bin/bash
set -x; set -e

name=eth-$1
data_path=/opt/eth/$name
sudo mkdir -p $data_path

if [ $1 != "1" ]; then
    link="--link eth-$[$1 - 1]:peer"
    remote="--remote peer --port 30303"
fi

sudo docker stop $name || true
sudo docker rm $name || true

sudo docker run \
    --detach \
    --name $name \
    --publish 3030$1:30303 \
    --volume $data_path:/data \
    --publish 808$1:8080 \
    $link \
    $net \
    --net host \
    abrkn/ethereum-cpp:076f787 \
    eth \
    --db-path /data \
    --upnp off \
    --mining on \
    --verbosity 10 \
    --json-rpc \
    --json-rpc-port 8080 \
    --force-mining \
    $remote

