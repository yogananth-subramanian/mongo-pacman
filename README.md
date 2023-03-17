# mongo-pacman

A demo of a pacman (cloned from https://github.com/font/pacman) configured for Stone Soup.

This is a two container application.
1. Pacman frontend, this is the UI and can be scaled to multiple hosts
2. A mongodb backend to store highscores.

## Install into Stone Soup
 
1. Import this repo https://github.com/jduimovich/mongo-pacman --- It will detect two components
2. Change the name of the mongo component (it will start with "mongo") to mongodb.This will ensure the service looked for will match.
   
   2a Alternatively, provide the name of the generate name for the mongo component to the pacman component as an
   environment variable `MONGO_SERVICE_HOST` to match the name of the stone soup environment 
3. Press create-application and wait for the build to complete.

Note, there will be two routes generated, use the pacman one to access the app. Use the frontend route. 


