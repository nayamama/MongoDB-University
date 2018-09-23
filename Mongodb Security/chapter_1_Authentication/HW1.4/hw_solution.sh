
killall mongod
sleep 5


./setup-hw-1.4.sh
sleep 10

mongo --eval "db.getSiblingDB('admin').adminCommand({authSchemaUpgrade: 1})"

./validate-hw-1.4.sh