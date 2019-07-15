#!/bin/bash

create_folder(){
	arg1=$1
	if [ ! -d $arg1 ]; then
		mkdir $arg1
		return 1
	else
		echo "$arg1 already exists"
		return 0
	fi
}

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
BASEFOLDER="$(dirname "$SCRIPTPATH")"

#echo $SCRIPTPATH
#echo $BASEFOLDER

compose_input="$SCRIPTPATH/docker-compose.template"
compose_output_filename="docker-compose.yml"
compose_output="$BASEFOLDER/compose/$compose_output_filename"

#set -x

sudo gpasswd -a "$USER" dialout

create_folder "$BASEFOLDER/compose"
if [ $? -eq "1" ]; then
	sed "s|{BASEFOLDER}|$BASEFOLDER|g" "$compose_input" > "$compose_output"
fi

create_folder "$BASEFOLDER/deconz"

create_folder "$BASEFOLDER/pimatic"
if [ $? -eq "1" ]; then
	cp "$SCRIPTPATH/config_default.json" "$BASEFOLDER/pimatic/config.json"
fi

create_folder "$BASEFOLDER/mqtt"
create_folder "$BASEFOLDER/mqtt/config"
if [ $? -eq "1" ]; then
	cp "$SCRIPTPATH/mosquitto.conf" "$BASEFOLDER/mqtt/config/mosquitto.conf"
fi
create_folder "$BASEFOLDER/mqtt/data"
if [ $? -eq "1" ]; then
	chmod -R 777 "$BASEFOLDER/mqtt/data"
fi
create_folder "$BASEFOLDER/mqtt/log"
if [ $? -eq "1" ]; then
	chmod -R 777 "$BASEFOLDER/mqtt/log"
fi



#chmod -R 777 "$BASEFOLDER/mqtt/config/mosquitto.conf"

docker build -f "$SCRIPTPATH/pimatic_0.9.50_dockerfile" -t pimatic_0.9.50 .

#docker run --name pimatic -dt -p 80:80 pimatic_0.9.50
#docker run --rm -ti -v /home/sven/my-pimatic-docker-setup/pimatic:/data -p 80:80 pimatic_0.9.50
#docker exec -it pimatic /bin/bash
#docker build -f pimatic_0.9.50_dockerfile -t pimatic_0.9.50 .

