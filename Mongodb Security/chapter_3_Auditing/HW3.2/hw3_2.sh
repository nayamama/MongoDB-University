#!/bin/bash

set -x

killall mongod
sleep 5

course="M310"
exercise="HW-3.2"
workingDir="$HOME/${course}-${exercise}"
logName="mongo.log"
auditLog="auditLog.json"

ports=(31320 31321 31322)
replSetName="TO_BE_SECURED"

host=`hostname -f`
initiateStr="rs.initiate({
                 _id: '$replSetName',
                 members: [
                  { _id: 1, host: '$host:31320' , priority: 1},
                  { _id: 2, host: '$host:31321' },
                  { _id: 3, host: '$host:31322' }
                 ]
                })"

# delete old working directory			
[ -d "$workingDir" ] && sudo rm -rf "$workingDir"

# create working folder
mkdir -p "$workingDir/"{r0,r1,r2}

# create directory for key file
mkdir -p "$workingDir/pki"

# create a keyfile and change mod
openssl rand -base64 756 > "$workingDir/pki/m310-keyfile"
chmod 400 "$workingDir/pki/m310-keyfile"

# launch mongod's
for ((i=0; i < ${#ports[@]}; i++))
do
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName" --port ${ports[$i]} --replSet $replSetName --keyFile "$workingDir/pki/m310-keyfile" --auditDestination file --auditFormat JSON --auditPath "$workingDir/r$i/$auditLog" --fork
done

# initiate the set
mongo admin --port ${ports[0]} --eval "$initiateStr"

# wait for all mongods are stable
sleep 30

# create the first user
mongo admin --port 31320 --eval 'db.createUser({user: "steve", pwd: "secret", roles: ["root"]})'

# shutdown all mongods
for ((i=0; i < ${#ports[@]}; i++))
do
  mongo admin -u steve -p secret --port ${ports[$i]} --quiet --eval 'db.shutdownServer()'
done

sleep 5

# restart mongods with audit filter to specific user
for ((i=0; i < ${#ports[@]}; i++))
do
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName" --port ${ports[$i]} --replSet $replSetName --keyFile "$workingDir/pki/m310-keyfile" --auditDestination file --auditFormat JSON --auditPath "$workingDir/r$i/$auditLog" --auditFilter '{ "users.user": "steve" }' --fork
done

sleep 30
