killall mongod
sleep 5

course="M310"
exercise="HW-2.2"
workingDir="$HOME/${course}-${exercise}"
dbDir="$workingDir/db"
logName="mongo.log"

ports=(31220 31221 31222)
replSetName="TO_BE_SECURED"

host=`hostname -f`
initiateStr="rs.initiate({
                 _id: '$replSetName',
                 members: [
                  { _id: 1, host: '$host:31220' },
                  { _id: 2, host: '$host:31221' },
                  { _id: 3, host: '$host:31222' }
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
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName" --port ${ports[$i]} --replSet $replSetName --keyFile "$workingDir/pki/m310-keyfile" --fork
done

# initiate the set
mongo admin --port ${ports[0]} --eval "$initiateStr"

# wait for all mongods are stable
sleep 30

# add the first user using localhost exception
mongo admin --port ${ports[0]} --eval 'db.createUser({user: "admin", pwd:"webscale", roles: [{role: "root", db: "admin"}]})'

# add other two users by authenticated root user
mongo admin --port ${ports[0]} -u "admin" -p "webscale" --eval 'db.createUser({user: "reader", pwd:"books", roles: [{role: "read", db: "acme"}]})'

mongo admin --port ${ports[0]} -u "admin" -p "webscale" --eval 'db.createUser({user: "writer", pwd:"typewriter", roles: [{role: "readWrite", db: "acme"}]})'