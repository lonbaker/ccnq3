@include = ->
  # traces_proxy
  # A proxy to access opened traces servers.
  request = require 'request'

  @get '/roles/traces/:host/:port', ->

    unless @session.roles?.indexOf 'access:traces:' >= 0
      return @send error:'Unauthorized'

    proxy = request
      uri: "http://#{@request.param 'host'}:#{@request.param 'port'}"
      jar: false
      timeout: 30000
    , (e) => if e? then @send error:e
    proxy.pipe @response
    return
