#!/bin/bash

set -x

killall mongod
sleep 5

course="M310"
exercise="MY-SET"
workingDir="$HOME/${course}-${exercise}"
dbDir="$workingDir/db"
logName="mongo.log"

ports=(31130 31131 31132)
replSetName="MY-SET"

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

# initiate the set and sleep for 30 seconds to wait for all nodes fully come up
mongo --port ${ports[0]} --eval "$initiateStr"
sleep 30

# get the port for master node
# mongo --port ${ports[0]]} --eval "rs.isMaster().primary" >> 1.txt
master_port=`mongo --port ${ports[0]]} --eval "rs.isMaster().primary" | tail -1 | cut -d ":" -f2`
echo "The port of master node is $master_port"

# create the first user
mongo --port "$master_port" --eval "db.getSiblingDB('\$external').runCommand({createUser: 'CN=client1,OU=MyClients,C=CA', roles: [{role: 'root', db: 'admin'}]})"

# shutdown all mongods
db="admin"
for ((i=0; i< ${#ports[@]}; i++))
do
  mongo $db --port ${ports[$i]} --eval "db.shutdownServer()"
done

# wait for all the mongods to exit
sleep 10

# launch mongods (both signing-ca.pem and ca-chain.pem work fine)
#mongod --sslMode requireSSL --sslClusterFile ~/shared/certificate_sign/server1.pem --sslCAFile ~/shared/certificate_sign/SigningCA/signing-ca.pem --sslPEMKeyFile ~/shared/certificate_sign/server1.pem --clusterAuthMode x509 --replSet "$replSetName" --dbpath "$workingDir/r0" --logpath "$workingDir/r0/$logName" --port 31130 --fork

#mongod --sslMode requireSSL --sslClusterFile ~/shared/certificate_sign/server2.pem --sslCAFile ~/shared/certificate_sign/SigningCA/signing-ca.pem --sslPEMKeyFile ~/shared/certificate_sign/server2.pem --clusterAuthMode x509 --replSet "$replSetName" --dbpath "$workingDir/r1" --logpath "$workingDir/r1/$logName" --port 31131 --fork

#mongod --sslMode requireSSL --sslClusterFile ~/shared/certificate_sign/server3.pem --sslCAFile ~/shared/certificate_sign/SigningCA/signing-ca.pem --sslPEMKeyFile ~/shared/certificate_sign/server3.pem --clusterAuthMode x509 --replSet "$replSetName" --dbpath "$workingDir/r2" --logpath "$workingDir/r2/$logName" --port 31132 --fork

mongod --sslMode requireSSL --sslClusterFile ~/shared/certificate_sign/server1.pem --sslCAFile ~/shared/certificate_sign/ca-chain.pem --sslPEMKeyFile ~/shared/certificate_sign/server1.pem --clusterAuthMode x509 --replSet "$replSetName" --dbpath "$workingDir/r0" --logpath "$workingDir/r0/$logName" --port 31130 --fork

mongod --sslMode requireSSL --sslClusterFile ~/shared/certificate_sign/server2.pem --sslCAFile ~/shared/certificate_sign/ca-chain.pem --sslPEMKeyFile ~/shared/certificate_sign/server2.pem --clusterAuthMode x509 --replSet "$replSetName" --dbpath "$workingDir/r1" --logpath "$workingDir/r1/$logName" --port 31131 --fork

mongod --sslMode requireSSL --sslClusterFile ~/shared/certificate_sign/server3.pem --sslCAFile ~/shared/certificate_sign/ca-chain.pem --sslPEMKeyFile ~/shared/certificate_sign/server3.pem --clusterAuthMode x509 --replSet "$replSetName" --dbpath "$workingDir/r2" --logpath "$workingDir/r2/$logName" --port 31132 --fork
sleep 30

#mongo --host "$host" --port 31130 --ssl --sslPEMKeyFile ~/shared/certificate_sign/client1.pem --sslCAFile ~/shared/certificate_sign/SigningCA/signing-ca.pem --eval "$initiateStr"

# mongo --host database.m310.mongodb.university --port 31130 --ssl --sslPEMKeyFile ~/shared/certificate_sign/client1.pem --sslCAFile ~/shared/certificate_sign/SigningCA/signing-ca.pem

# db.getSiblingDB("$external").auth({user: "CN=client1,OU=MyClients,C=CA", mechanism: "MONGODB-X509"})
# db.getSiblingDB("$external").runCommand({createUser: "CN=client2,OU=MyClients,C=CA", roles: [{role: "userAdminAnyDatabase", db: "admin"}]})



