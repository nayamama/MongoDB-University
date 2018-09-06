#!/usr/bin/env bash

function clear_running_processes(){
  clear
  killall mongod
  killall mongos
  sleep 5
  echo "All running mongod or mongos processes all killed"
}

function start_first_replicaset(){
  echo "start provisioning the first replica set"
  mongod -f /shared/sharding/mongod-repl-1.conf
  mongod -f /shared/sharding/mongod-repl-2.conf
  mongod -f /shared/sharding/mongod-repl-3.conf
  echo "the first replica set is ready..."
}

function start_config_server(){
  echo "start config server of sharding cluster"
  mongod -f /shared/sharding/csvr1.conf
  mongod -f /shared/sharding/csvr2.conf
  mongod -f /shared/sharding/csvr3.conf
  echo "the config replica set is ready..."
}

function start_second_replicaset(){
  echo "start provisioning the second replica set"
  mongod -f /shared/sharding/mongod-shard2-1.conf
  mongod -f /shared/sharding/mongod-shard2-2.conf
  mongod -f /shared/sharding/mongod-shard2-3.conf
  echo "the second replica set is ready..."
}

function start_mongos(){
  echo "start mongos"
  mongos -f /shared/sharding/mongos.conf
  echo "the mongos is ready"
}

function show_info(){
  echo "the ip and port information of all services"
  OUTPUT="$(netstat -ntulp | grep -e mongod -e mongos | grep -v 127.0.0.1 | awk '{print $4, $7}')"
  echo "${OUTPUT}"
  echo "connect a client to mongos with authenticated user"
  mongo -u "m103-admin" -p "m103-pass" --port 26000 --authenticationDatabase "admin"
}

clear_running_processes
start_config_server
start_first_replicaset
start_second_replicaset
start_mongos
sleep 10
show_info


