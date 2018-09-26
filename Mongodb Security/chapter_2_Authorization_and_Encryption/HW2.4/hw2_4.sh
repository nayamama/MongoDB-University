#!/bin/bash

killall mongod
sleep 5

course="M310"
exercise="HW-2.4"
workingDir="$HOME/${course}-${exercise}"
logName="mongo.log"

ports=(31240 31241 31242)
replSetName="TO_BE_SECURED"

host=`hostname -f`
initiateStr="rs.initiate({
                 _id: '$replSetName',
                 members: [
                  { _id: 1, host: '$host:31240' },
                  { _id: 2, host: '$host:31241' },
                  { _id: 3, host: '$host:31242' }
                 ]
                })"

# delete old working directory			
[ -d "$workingDir" ] && sudo rm -rf "$workingDir"

# create working folder
mkdir -p "$workingDir/"{r0,r1,r2}

# launch mongod's
for ((i=0; i < ${#ports[@]}; i++))
do
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName" --port ${ports[$i]} --replSet $replSetName  --fork --sslMode requireSSL --sslCAFile certs/ca.pem --sslPEMKeyFile certs/server.pem
done

sleep 10

# Initiates the replica set.
mongo --port ${ports[0]} --host $host --ssl --sslPEMKeyFile certs/client.pem --sslCAFile certs/ca.pem --eval "$initiateStr"

sleep 30
