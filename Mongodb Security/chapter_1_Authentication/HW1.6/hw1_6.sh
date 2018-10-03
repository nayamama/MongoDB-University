#!/bin/bash

set -x

killall mongod
sleep 5

# add user vagrant to sasl group
sudo usermod -a -G sasl vagrant

course="M310"
exercise="HW-1.6"
workingDir="$HOME/${course}-${exercise}"
dbDir="$workingDir/db"
logName="mongodb.log"
ports=(31160 31161 31162)
replSetName="TO_BE_SECURED"

host=`hostname -f`
initiateStr="rs.initiate({
                 _id: '$replSetName',
                 members: [
                  { _id: 1, host: '$host:31160', priority: 1 },
                  { _id: 2, host: '$host:31161' },
                  { _id: 3, host: '$host:31162' }
                 ]
                })"

# delete old working directory
[ -d "$workingDir" ] && sudo rm -rf "$workingDir"

# Creates the working directories.
mkdir -p "$workingDir/"{r0,r1,r2}

# create directory for key file
mkdir -p "$workingDir/pki"

# create a keyfile and change mod
openssl rand -base64 756 > "$workingDir/pki/m310-keyfile"
chmod 400 "$workingDir/pki/m310-keyfile"

# Launch the mongo replica set with LDAP support enabled
for ((i=0; i < ${#ports[@]}; i++))
do
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName" --port ${ports[$i]} --replSet $replSetName --fork --auth --setParameter authenticationMechanisms=PLAIN --setParameter saslauthdPath="/var/run/saslauthd/mux" --keyFile "$workingDir/pki/m310-keyfile"
done

sleep 10  

# Initializes the replica set. 
mongo --port ${ports[0]} --eval "$initiateStr" 
sleep 30

# add the first user using localhost exception
mongo --port 31160 --eval "db.getSiblingDB('\$external').createUser({user: 'alice',  roles: [{role: 'root', db: 'admin'}]})"

# change owner ship of sasl in case sasl change the permission of mux after every time restart
# sudo chmod 755 /var/run/saslauthd

# authentication
mongo --port 31160 --eval 'db.getSiblingDB("$external").auth({mechanism: "PLAIN", user: "alice", pwd: "password", digestPassword: false})'