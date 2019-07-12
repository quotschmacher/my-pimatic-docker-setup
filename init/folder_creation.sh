#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
BASEFOLDER="$(dirname "$SCRIPTPATH")"

#echo $SCRIPTPATH
#echo $BASEFOLDER

compose_input="$SCRIPTPATH/docker-compose.template"
compose_output_filename="docker-compose.yml"
compose_output="$BASEFOLDER/compose/$compose_output_filename"

set -x

mkdir "$BASEFOLDER/compose"

#eval "echo \"$(cat $compose_input)\"" > $compose_output

sed "s|{BASEFOLDER}|$BASEFOLDER|g" "$compose_input" > "$compose_output"

mkdir "$BASEFOLDER/deconz"
mkdir "$BASEFOLDER/mqtt"
mkdir "$BASEFOLDER/mqtt/config"
mkdir "$BASEFOLDER/mqtt/data"
mkdir "$BASEFOLDER/mqtt/log"

chmod -R 777 "$BASEFOLDER/mqtt/data"
chmod -R 777 "$BASEFOLDER/mqtt/log"

cp "$SCRIPTPATH/mosquitto.conf" "$BASEFOLDER/mqtt/config/mosquitto.conf"

chmod -R 777 "$BASEFOLDER/mqtt/config/mosquitto.conf"

docker build -f "$SCRIPTPATH/pimatic_0.9.50_dockerfile" -t pimatic_0.9.50 .

#docker run --name pimatic -dt -p 80:80 pimatic_0.9.50
#docker build -f pimatic_0.9.50_dockerfile -t pimatic_0.9.50 .


#mkdir deconz
#mkdir mqtt
#mkdir mqtt/log
#chmod -R 777 mqtt/log
