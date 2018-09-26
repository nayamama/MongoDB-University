#!/bin/bash

killall mongod
sleep 5

course="M310"
exercise="HW-2.3"
workingDir="$HOME/${course}-${exercise}"
dbDir="$workingDir/db"
logName="mongo.log"

port=31230

host=`hostname -f`

# delete old working directory			
[ -d "$workingDir" ] && sudo rm -rf "$workingDir"

# create working folder
mkdir "$workingDir"

# launch mongod
mongod --dbpath "$workingDir" --logpath "$workingDir/$logName" --port $port --fork

# create the first user using localhost exception
# mongo admin --port $port --eval 'db.createUser({user: "naya", pwd:"password", roles: [{role: "root", db: "admin"}]})'

mongo admin --port $port --eval 'db.createRole({
  role: "HRDEPARTMENT",
  privileges: [{
      resource: { db: "HR", collection: "" },
      actions: [ "find", "dropUser" ]
    }, 
	{
      resource: { db: "HR", collection: "employees" },
      actions: [ "insert" ]
    }
  ],
  roles:[]
})
'

mongo admin --port $port --eval 'db.createRole({
  role: "MANAGEMENT",
  privileges: [{
    resource: { db: "HR", collection: "" },
    actions: [ "insert" ]
  }],
  roles:[{
    role: "dbOwner", db: "HR"
  }]
})'

mongo admin --port $port --eval 'db.createRole({
  role: "EMPLOYEEPORTAL",
  privileges: [{
    resource: { db: "HR", collection: "employees" },
    actions: [ "find", "update" ]
  }],
  roles:[]
})'

