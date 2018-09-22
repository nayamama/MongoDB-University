#!/bin/bash

course="M310"
exercise="HW-1.2"
workingDir="$HOME/${course}-${exercise}"
dbDir="$workingDir/db"
logName="mongo.log"

ports=(31120 31121 31122)
replSetName="TO_BE_SECURED"

host=`hostname -f`
initiateStr="rs.initiate({
                 _id: '$replSetName',
                 members: [
                  { _id: 1, host: '$host:31120' },
                  { _id: 2, host: '$host:31121' },
                  { _id: 3, host: '$host:31122' }
                 ]
                })"

# create working folder
mkdir -p "$workingDir/"{r0,r1,r2}

# launch mongod's
for ((i=0; i < ${#ports[@]}; i++))
do
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName.log" --port ${ports[$i]} --replSet $replSetName --fork
done

# initiate the set
mongo --port ${ports[0]} --eval "$initiateStr"

######################### HW PART #####################################

# create directory for key file
mkdir -p "$workingDir/pki"

# create a keyfile and change mod
openssl rand -base64 756 > "$workingDir/pki/m310-keyfile"
chmod 400 "$workingDir/pki/m310-keyfile"

# shutdown all mongods
db="admin"
for ((i=0; i< ${#ports[@]}; i++))
do
  mongo $db --port ${ports[$i]} --eval "db.shutdownServer()"
done

# wait for all the mongods to exit
sleep 3

# restart all mongos
for ((i=0; i < ${#ports[@]}; i++))
do
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName" --port ${ports[$i]} --replSet $replSetName --keyFile "$workingDir/pki/m310-keyfile" --fork
done

# wait for all mongods are stable
sleep 10

# create user
user="admin"
pwd="webscale"
role="root"

mongo $db --port ${ports[0]} --eval "db.createUser({user: '$user', pwd: '$pwd', roles: ['$role']})"

