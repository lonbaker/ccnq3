#!/usr/bin/env coffee
###
(c) 2010 Stephane Alnet
Released under the AGPL3 license
###

# The host records in the provisioning database may contain
# attachment scripts, whose job it is to maintain
# invariants inside the given host.

util = require 'util'

handler = require './handlers'

# Main

request = require 'request'
qs = require 'querystring'
cdb_changes = require 'cdb_changes'

replicate = require('./replicate').replicate

minutes = 60 * 1000
default_replicate_interval = 5 * minutes

require('ccnq3_config').get (config) ->

  replicate config

  replication = -> replicate config

  # The replicator tends to die randomly, so restart it at regular intervals.
  setInterval replication, config.replicate_interval ? default_replicate_interval

  # Main agent code

  options =
    uri: config.provisioning.host_couchdb_uri
    filter_name: "host/hostname"
    filter_params:
      hostname: config.host

  new_config = config

  cdb_changes.monitor options, (p) ->
    if p.error? then return util.log(p.error)

    replicate config

    [old_config,new_config] = [new_config,p]

    if new_config._attachments?

      base_uri = new_config.provisioning.host_couchdb_uri + '/' + qs.escape "host@#{new_config.host}"

      for attachment_name, info in new_config._attachments
        request base_uri + '/' + qs.escape attachment_name, (err,code) ->
          if err
            return util.log err

          handler[info.content_type]? code, old_config, new_config
