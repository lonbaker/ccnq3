#!/usr/bin/env coffee

couchapp = require 'couchapp'

# Load Configuration
fs = require('fs')
config_location = process.env.npm_package_config_bootstrap_file
config = JSON.parse(fs.readFileSync(config_location, 'utf8'))

uri = "#{config.couchdb_uri}/_users"

couchapp.createApp require("./users"), uri, (app)-> app.push()
