#!/bin/bash

killall mongod
sleep 5

course="M310"
exercise="HW-2.1"
workingDir="$HOME/${course}-${exercise}"
dbDir="$workingDir/db"
logName="mongo.log"

ports=(31210 31211 31212)
replSetName="TO_BE_SECURED"

host=`hostname -f`
initiateStr="rs.initiate({
                 _id: '$replSetName',
                 members: [
                  { _id: 1, host: '$host:31210' },
                  { _id: 2, host: '$host:31211' },
                  { _id: 3, host: '$host:31212' }
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
  #mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName" --port ${ports[$i]} --replSet $replSetName --fork
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName" --port ${ports[$i]} --replSet $replSetName --keyFile "$workingDir/pki/m310-keyfile" --fork
done

# initiate the set
mongo admin --port ${ports[0]} --eval "$initiateStr"

# wait for all mongods are stable
sleep 30

# add the first user with lcalhost exception
mongo admin --port ${ports[0]} --eval 'db.createUser({user: "userAdmin", pwd:"badges", roles: [{role: "userAdminAnyDatabase", db: "admin"}]})'

# add three more users by authenticated user
mongo admin --port ${ports[0]} -u "userAdmin" -p "badges" --eval 'db.createUser({user: "sysAdmin", pwd:"cables", roles: [{role: "clusterManager", db: "admin"}]})'

mongo admin --port ${ports[0]} -u "userAdmin" -p "badges" --eval 'db.createUser({user: "dbAdmin", pwd:"collections", roles: [{role: "dbAdminAnyDatabase", db: "admin"}]})'

mongo admin --port ${ports[0]} -u "userAdmin" -p "badges" --eval 'db.createUser({user: "dataLoader", pwd:"dumpin", roles: [{role: "readWriteAnyDatabase", db: "admin"}]})'
