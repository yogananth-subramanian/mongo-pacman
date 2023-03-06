#!/bin/bash

# This is the entrypoint for the docker container
# this will initialize mongo and start the server
# and keep it running 

# Set default arguments
: ${MONGO_DATA_DIR:=/data/db}

# Check for the expected command
if [ -z "$(ls -A ${MONGO_DATA_DIR}/journal)" ]; then 
	echo "-----------------------------------------------------------"
	echo 
	echo "=> An empty or uninitialized MongoDB volume is detected in $MONGO_DATA_DIR"
	echo "=> Installing MongoDB ..."
#	"$MONGO_HOME/bin/mongod" --quiet --dbpath "$MONGO_DATA_DIR" --logpath /dev/null --bind_ip_all --fork 

	"$MONGO_HOME/bin/mongod"  --dbpath "$MONGO_DATA_DIR"   --bind_ip_all $CMDARG & 
	MONGO_PID=$!  
	echo "=>Mongo running at $MONGO_PID" 
	echo "Waiting for mongo to start " 
	sleep 30 
	echo "=> Creating pacman database ..."
	mongosh < /mongodb/scripts/initmongo
	mongosh < /mongodb/scripts/showmongo    
	echo "-----------------------------------------------------------" 
	echo "running wait"
	wait 
	echo "wait completed is mongo running " 
	REP=10
	while true
	do    
		OUTPUT=$(mongosh < /mongodb/scripts/showmongo 2>&1)  
		if echo "$OUTPUT" | grep -q "ECONNREFUSED"; then
   			echo "$REP ECONNREFUSED - Mongo service missing"
			let REP--
			if [ $REP == 0 ]
			then
				break 
			fi
		else  
   			echo "$REP Mongo service ok"
		fi
		sleep 10
	done   
	echo "Mongo backend terminated - restarting mongo" 
else
	echo "=> Using an existing volume of MongoDB"
fi

# Start MongoDB
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
echo 
echo "=> Starting MongoDB in full logging mode ..."
#exec "$MONGO_HOME/bin/mongod" --quiet --dbpath "$MONGO_DATA_DIR" --logpath /dev/null --bind_ip_all $CMDARG
exec "$MONGO_HOME/bin/mongod"  --dbpath "$MONGO_DATA_DIR"   --bind_ip_all $CMDARG
#exec "$@"
 
echo "FATAL - Mongo exited "  
echo "Waiting 10 minutes to allow debug"
sleep 600 
echo "When this exits, the pod will restart."