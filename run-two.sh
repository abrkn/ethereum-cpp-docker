#!/usr/bin/env bash
for i in 1 2; do ./run.sh $i; done
sudo docker logs -f eth-1

