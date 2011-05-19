###
(c) 2010 Stephane Alnet
Released under the GPL3 license
###

# Load Configuration
fs = require('fs')
config_location = 'profile.config'
profile_config = JSON.parse(fs.readFileSync(config_location, 'utf8'))

def profile_config: profile_config

# Load CouchDB
cdb = require process.cwd()+'/../../../lib/cdb.coffee'

def users_cdb: cdb.new (profile_config.users_couchdb_uri)

get '/profile.json': ->
  if session.logged_in?
    users_cdb.get session.logged_in, (p) ->
      send p.profile
  else
    send error:'Not logged in.'
