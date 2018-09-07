# config server
rs.initiate()
db.createUser({
  user: "m103-admin",
  pwd: "m103-pass",
  roles: [
    {role: "root", db: "admin"}
  ]
})
db.auth("m103-admin", "m103-pass")  # <- authenticate as the super user
rs.add("192.168.103.100:26002")
rs.add("192.168.103.100:26003")

# start mongos
mongos -f mongos.conf
mongo --port 26000 -u "m103-admin" -p "m103-pass" --authenticationDatabase "admin"
sh.status()  # <- get sharding data from mongos
sh.addShard("m103-repl/192.168.103.100:27012")  # <- we jsut need to specify one node, mongo can discover others.

# sharding collection

use <database>
sh.enableSharding("<database>")
db.collection.createIndex({"sku": 1})
sh.shardCollection("<database>.<collection>", {"sku": 1})
db.products.getShardDistribution()