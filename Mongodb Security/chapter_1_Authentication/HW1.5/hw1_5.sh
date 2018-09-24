#!/bin/bash

set -x

killall mongod
sleep 5

course="M310"
exercise="HW-1.5"
workingDir="$HOME/${course}-${exercise}"
logName="mongodb.log"

ports=(31150 31151 31152)
replSetName="TO_BE_SECURED"

host=`hostname -f`
initiateStr="rs.initiate({
                 _id: '$replSetName',
                 members: [
                  { _id: 1, host: '$host:31150', priority: 1 },
                  { _id: 2, host: '$host:31151' },
                  { _id: 3, host: '$host:31152' }
                 ]
                })"

# delete old working directory			
[ -d "$workingDir" ] && sudo rm -rf "$workingDir"

# create working folder
mkdir -p "$workingDir/"{r0,r1,r2}

# launch mongod's without authentication
for ((i=0; i < ${#ports[@]}; i++))
do
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName" --port ${ports[$i]} --replSet $replSetName --fork
done

# initiate the set
mongo --port ${ports[0]} --eval "$initiateStr"
sleep 30

# add will as the first user
mongo admin --port ${ports[0]} --eval "db.createUser({user: 'will', pwd: '\$uperAdmin', roles: ['root']})"

# add naya as user with certificate
# mongo --port "$master_port" --eval "db.getSiblingDB('\$external').runCommand({createUser: '$user', roles: [{role: 'userAdminAnyDatabase', db: 'admin'}]})"

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
sleep 5

# relaunch the mongods with keyfile as clusterAuthMode and x.509 as client authentications
for ((i=0; i < ${#ports[@]}; i++))
do
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName" --port ${ports[$i]} --replSet $replSetName --fork --keyFile "$workingDir/pki/m310-keyfile" --sslMode requireSSL --clusterAuthMode keyFile --sslCAFile certs/ca.pem --sslPEMKeyFile certs/server.pem 
done

sleep 30
# login from client
# mongo --host database.m310.mongodb.university --sslPEMKeyFile "certs/client.pem" --sslCAFile "certs/ca.pem" --ssl --port 31150

# get the subject from client private certificate
subject=`openssl x509 -in certs/client.pem -inform PEM -subject -nameopt RFC2253 -noout`
user=${subject:9:72}
echo "The user name is $user"

# get the port for master node
# mongo --port ${ports[0]]} --eval "rs.isMaster().primary" >> 1.txt
master_port=`mongo --host "$host" --sslPEMKeyFile "certs/client.pem" --sslCAFile "certs/ca.pem" --ssl --port ${ports[0]} --eval "rs.isMaster().primary" | tail -1 | cut -d ":" -f2`
echo "The port of master node is $master_port"

# add certificated user to admin database (always use quatos for quering string values)
printf 'use admin\ndb.auth("will","\$uperAdmin")\nuse $external\ndb.createUser({user: "%s", roles:[{ role: "userAdminAnyDatabase", db: "admin" }]})' "$user" | mongo --host "$host" --sslPEMKeyFile "certs/client.pem" --sslCAFile "certs/ca.pem" --ssl --port "$master_port"