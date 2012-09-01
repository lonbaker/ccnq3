#!/usr/bin/env coffee

pico = require 'pico'

require('ccnq3_config') (config) ->

  provisioning_uri = config.provisioning.local_couchdb_uri
  provisioning = pico provisioning_uri
  provisioning.compact pico.log
