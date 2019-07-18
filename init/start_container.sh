#!/bin/bash

docker container stop deconz && docker container rm deconz && docker run -d \
    --name=deconz \
    --net=host \
    --restart=always \
    -v /home/sven/my-pimatic-docker-setup/deconz:/root/.local/share/dresden-elektronik/deCONZ \
    -e DECONZ_WEB_PORT=8080 \
    --device=/dec/ttyACM0 \
    marthoc/deconz

docker container stop pimatic && docker container rm pimatic && docker run -dt \
    --name=pimatic \
    -p 80:80 \
    -v /home/sven/my-pimatic-docker-setup/pimatic:/data \
    pimatic_0.9.50

#docker inspect -f '{{.State.Running}}' pimatic