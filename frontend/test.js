'use strict';

var MongoClient = require('mongodb').MongoClient; 
var _db;

var url="mongodb://mongodb:27017"
if(process.env.TEST_URL) {
    url=process.env.TEST_URL
}
var dbName="pacman"
var options =
{
    readPreference: 'secondaryPreferred'
}

console.log ("URL = ", url) 
function Database() { 
    this.connect = function(app, callback) { 
            console.log ("CONNECTING ", url)
            console.log ("Options ", options)
            MongoClient.connect( url,
                                 options,
                                function (err, client) {
                                    if (err) {
                                        console.log(err);
                                        console.log(config.database.url);
                                        console.log(config.database.options);
                                    } else {
                                        console.log ("SUCCESS!!!! ",  url)
                                        const db = client.db(dbName); 
                                        _db = db;
                                        app.db = db;
                                        console.log ("DB DB DO !!!! ", db)
                                       
                                    }
                                    callback(err);
                                });
    }

    this.getDb = function(app, callback) {
        if (!_db) {
            this.connect(app, function(err) {
                if (err) {
                    console.log('Failed to connect to database server');
                } else {
                    console.log('Connected to database server successfully');
                }

                callback(err, _db);
            });
        } else {
            callback(null, _db);
        }

    }
}

var app= { } 
var database=new Database()
database.connect(app, function(err) {
    if (err) {
        console.log('PACMAN: Failed to connect to database server');
    } else {
        console.log('PACMAN: Connected to database server successfully');
    } 
    console.log ("APP = ", app)
})