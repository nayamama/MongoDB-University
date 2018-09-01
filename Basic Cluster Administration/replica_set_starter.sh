#! /bin/bash

clear

echo "The Mongo replica set cluster start to provision..."

mongod -f /shared/replicaConf/mongod-repl-1.conf
mongod -f /shared/replicaConf/mongod-repl-2.conf
mongod -f /shared/replicaConf/mongod-repl-3.conf

echo "All three nodes of cluster are ready."

echo "The client to connect to primary node."

mongo --host "m103-repl/192.168.103.100:27001" -u "m103-admin" -p "m103-pass" --authenticationDatabase "admin"




