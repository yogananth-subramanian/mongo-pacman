'use strict';

var MongoClient = require('mongodb').MongoClient;
var config = require('./config');
var _db;

function Database() {

    this.connect = function(app, callback) {

            console.log ("CONNECTING ", config.database.url)
            console.log ("Options ", config.database.options)
            MongoClient.connect(config.database.url,
                                config.database.options,
                                function (err, client) {
                                    if (err) {
                                        console.log(err);
                                        console.log(config.database.url);
                                        console.log(config.database.options);
                                    } else {
                                        console.log ("SUCCESS!!!! ", config.database.url)
                                        const db = client.db(config.database.dbName); 
                                        _db = db;
                                        app.locals.db = db;
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

module.exports = exports = new Database(); // Singleton
