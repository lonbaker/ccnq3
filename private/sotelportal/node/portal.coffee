#!/usr/bin/env zappa
###
# (c) 2010 Stephane Alnet
# Released under the AGPL3 license
###

app "portal", (server) ->
  # Configuration
  fs = require 'fs'
  config_location = process.env.npm_package_config_config_file
  config = JSON.parse(fs.readFileSync(config_location, 'utf8')).session
  # Session store
  express = require('express')
  if config.memcached_store
    MemcachedStore = require 'connect-memcached'
    store = new MemcachedStore(config.memcached_store)
  if config.redis_store
    RedisStore = require('connect-redis')(express)
    store = new RedisStore(config.redis_store)

  server.use express.logger()
  server.use express.bodyParser()
  server.use express.cookieParser()
  server.use express.session( secret: config.secret, store: store )
  server.use express.methodOverride()

#
# Configuration
#

fs = require 'fs'
config_location = process.env.npm_package_config_config_file
config = JSON.parse(fs.readFileSync(config_location, 'utf8'))

def config: config

def cdb: require 'cdb'

#
# Special rendering helpers
#

# Default layout is to render a widget
layout ->
  html -> @content

helper widget: (t) ->
  @session = session
  render t #, layout: 'widget'

# This gets everything started.
client main: ->
  $(document).ready ->
    default_scripts = [
        '/public/js/jquery-ui',
        '/public/js/jquery.validate',
        '/p/content'
    ]
    for s in default_scripts
      $.getScript s + '.js'

include 'content.coffee'
include 'login.coffee'
