#!/bin/bash

#set -x

container_running(){
	arg1=$1
	#if [ `docker inspect -f '{{.State.Running}}' $1` = "true" ]; then
	if [ `docker ps -q -f name=$1` ]; then
		echo "container $arg1 laeuft"
		return 1
	else
		echo "container $arg1 laeuft nicht"
		return 0
	fi
}

container_available(){
	arg1=$1
	if [ `docker ps -aq -f status=created -f name=$1` ] || [ `docker ps -aq -f status=exited -f name=$1` ]; then
		echo "container $arg1 vorhanden"
		return 1
	else
		echo "container $arg1 nicht vorhanden"
		return 0
	fi
}

remove_container(){
	arg1=$1
	container_running $arg1
	if [ $? -eq "1" ]; then
		docker container stop $arg1
	fi
	container_available $arg1
	if [ $? -eq "1" ]; then
		docker container rm $arg1
	fi
}

remove_container "deconz"

docker create \
    --name=deconz \
    --net=host \
    --restart=unless-stopped \
    -e TZ=Europe/Berlin \
    -v /home/sven/my-pimatic-docker-setup/deconz:/root/.local/share/dresden-elektronik/deCONZ \
    -e DECONZ_WEB_PORT=8080 \
    --device=/dec/ttyACM0 \
    marthoc/deconz


remove_container "pimatic"

docker create \
    --name=pimatic \
    --restart=unless-stopped \
    -e TZ=Europe/Berlin \
    -p 80:80 \
    -v /home/sven/my-pimatic-docker-setup/pimatic:/data \
    pimatic_0.9.50

docker start deconz
docker start pimatic

#docker create \
#--name=kodi-headless \
#-v ~/docker/kodi:/config/.kodi \
#-e PGID=gid -e PUID=uid \
#-e TZ=Europe/Berlin \
#-p 8090:8080 \
#-p 9090:9090 \
#-p 9777:9777/udp \
#linuxserver/kodi-headless
