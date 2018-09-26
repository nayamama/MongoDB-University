#!/bin/bash

set -x

killall mongod
sleep 5

course="M310"
exercise="HW-2.5"
workingDir="$HOME/${course}-${exercise}"
logName="mongo.log"

ports=(31250 31251 31252)
replSetName="UNENCRYPTED"

host=`hostname -f`

# delete old working directory			
[ -d "$workingDir" ] && sudo rm -rf "$workingDir"

# set up a basic replica set without encrypted storage engine
./setup-hw-2.5.sh

# create key file to use as the external master key
openssl rand -base64 32 > "$workingDir/mongodb-keyfile"
chmod 600 "$workingDir/mongodb-keyfile"

# shutdown two secondaries and delete the old database files
for ((i=1; i < ${#ports[@]}; i++))
do
  mongo admin --port ${ports[$i]} --quiet --eval "db.shutdownServer()"
  sleep 3
  rm -rf "$workingDir/r$i"
  mkdir -p "$workingDir/r$i"
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName" --port ${ports[$i]} --replSet $replSetName --fork --enableEncryption --encryptionKeyFile "$workingDir/mongodb-keyfile"
  sleep 10
done

# shut down primary
mongo admin --port ${ports[0]} --quiet --eval "rs.stepDown()"
mongo admin --port ${ports[0]} --quiet --eval "db.shutdownServer()"
sleep 3
rm -rf "$workingDir/r0"
mkdir -p "$workingDir/r0"
mongod --dbpath "$workingDir/r0" --logpath "$workingDir/r0/$logName" --port ${ports[0]} --replSet $replSetName --fork --enableEncryption --encryptionKeyFile "$workingDir/mongodb-keyfile"

sleep 30

