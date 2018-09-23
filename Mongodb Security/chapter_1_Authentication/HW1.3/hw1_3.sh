#!/bin/bash

set -x

killall mongod
sleep 5

course="M310"
exercise="HW-1.3"
workingDir="$HOME/${course}-${exercise}"
dbDir="$workingDir/db"
logName="mongo.log"

ports=(31130 31131 31132)
replSetName="TO_BE_SECURED"

host=`hostname -f`
initiateStr="rs.initiate({
                 _id: '$replSetName',
                 members: [
                  { _id: 1, host: '$host:31130', priority: 1 },
                  { _id: 2, host: '$host:31131' },
                  { _id: 3, host: '$host:31132' }
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

# get the subject from client private certificate
subject=`openssl x509 -in certs/client.pem -inform PEM -subject -nameopt RFC2253 -noout`
user=${subject:9:72}
echo "The user name is $user"

# initiate the set and sleep for 30 seconds to wait for all nodes fully come up
mongo --port ${ports[0]} --eval "$initiateStr"
sleep 30

# get the port for master node
# mongo --port ${ports[0]]} --eval "rs.isMaster().primary" >> 1.txt
master_port=`mongo --port ${ports[0]]} --eval "rs.isMaster().primary" | tail -1 | cut -d ":" -f2`
echo "The port of master node is $master_port"

# create the first user
mongo --port "$master_port" --eval "db.getSiblingDB('\$external').runCommand({createUser: 'C=US,ST=New York,L=New York City,O=MongoDB,OU=University2,CN=M310 Client', roles: [{role: 'root', db: 'admin'}]})"

# shutdown all mongods
db="admin"
for ((i=0; i< ${#ports[@]}; i++))
do
  mongo $db --port ${ports[$i]} --eval "db.shutdownServer()"
done

# wait for all the mongods to exit
sleep 10

# relaunch the mongods with authentication
for ((i=0; i < ${#ports[@]}; i++))
do
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName" --port ${ports[$i]} --replSet $replSetName --fork --sslMode requireSSL --clusterAuthMode x509 --sslPEMKeyFile certs/server.pem --sslCAFile certs/ca.pem  --sslClusterFile certs/server.pem
done
