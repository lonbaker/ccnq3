#!/usr/bin/env coffee

couchapp = require 'couchapp'
cdb = require 'cdb'

push_script = (uri,script,cb) ->
  couchapp.createApp require("./#{script}"), uri, (app)-> app.push(cb)

# Load Configuration
config = require('ccnq3_config').config

# ==== Commands ====
uri = config.commands.couchdb_uri
commands = cdb.new(uri)
commands.create ->

  commands.security (p)->
    p.admins ||= {}
    p.admins.roles ||= []
    push p.admins.roles,  "commands_admin"  if p.admins?.roles.indexOf("commands_admin") < 0
    p.readers ||= {}
    p.readers.roles ||= []
    push p.readers.roles, "commands_reader" if p.readers?.roles.indexOf("commands_reader") < 0
    push p.readers.roles, "commands_writer" if p.readers?.roles.indexOf("commands_reader") < 0
    push p.readers.roles, "host"            if p.readers?.roles.indexOf("host") < 0

  push_script uri, 'commands'

# ==== Logger ====
uri = config.logger.couchdb_uri
logger = cdb.new(uri)
logger.create ->

  logger.security (p)->
    push p.admins.roles,  "logger_admin"  if p.admins?.roles.indexOf("logger_admin") < 0
    push p.readers.roles, "logger_reader" if p.readers?.roles.indexOf("logger_reader") < 0
    push p.readers.roles, "logger_writer" if p.readers?.roles.indexOf("logger_reader") < 0
    push p.readers.roles, "host"          if p.readers?.roles.indexOf("host") < 0

  push_script uri, 'logger'
