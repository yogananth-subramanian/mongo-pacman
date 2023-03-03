#!/bin/bash
 
echo "NODE VERSION:"
node --version

echo "NPM  VERSION:"
npm --version

# export MONGO_AUTH_USER=pacman
# export MONGO_AUTH_PWD=pacman
echo "run pacman"
cd /pacman  
node bin/server.js