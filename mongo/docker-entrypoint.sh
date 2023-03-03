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
	sleep 10
	echo "=> Creating pacman database ..."
	mongosh < /mongodb/scripts/initmongo
	mongosh < /mongodb/scripts/showmongo    
	echo "-----------------------------------------------------------" 
	echo "running wait"
	wait 
	echo "wait completed" 
	while true
	do 
		echo "Waiting 600"
		sleep 600
	done
else
	echo "=> Using an existing volume of MongoDB"
fi

# Start MongoDB
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
echo 
echo "=> Starting MongoDB in full logging mode ..."
#exec "$MONGO_HOME/bin/mongod" --quiet --dbpath "$MONGO_DATA_DIR" --logpath /dev/null --bind_ip_all $CMDARG
exec "$MONGO_HOME/bin/mongod"  --dbpath "$MONGO_DATA_DIR"   --bind_ip_all $CMDARG
exec "$@"
 