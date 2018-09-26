#!/bin/bash

set -x

killall mongod
sleep 5

course="M310"
exercise="HW-2.6"
workingDir="$HOME/${course}-${exercise}"
dbDir="$workingDir/db"
logName="mongo.log"

port=31260

server_host="infrastructure.m310.mongodb.university"
server_ip="192.168.31.200"

# delete old working directory			
[ -d "$workingDir" ] && sudo rm -rf "$workingDir"

# create working folder
mkdir -p "$dbDir"

# launch mongod with absolute path
mongod --dbpath "$dbDir" --logpath "$workingDir/$logName" --port $port --fork --enableEncryption --kmipServerName "$server_host" --kmipServerCAFile /home/vagrant/shared/certs/ca.pem --kmipClientCertificateFile /home/vagrant/shared/certs/client.pem --kmipPort 5696