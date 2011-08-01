###
(c) 2010 Stephane Alnet
Released under the AGPL3 license
###

# Load CouchDB
cdb = require 'cdb'

def cdb: cdb

using 'url'
using 'querystring'

client login: ->
  $(document).ready ->

    # Log into the main portal (this application).
    main_login = (next) ->
      ajax_options =
        type: 'post'
        url: '/u/login.json'
        data:
          username: $('#login_username').val()
          password: $('#login_password').val()
        dataType: 'json'
        success: (data) ->
          if not data.ok
            $('#login_error').html('Sign in failed')
            return
          next()

      $('#login_error').html("")
      $.ajax(ajax_options)

    # Use data.couchdb to login as well
    couchdb_login = (next) ->
      couchdb_options =
        type: 'post'
        url: '/_session'
        username: $('#login_username').val()
        password: $('#login_password').val()
        data:
          name: $('#login_username').val()
          password: $('#login_password').val()
        dataType:'json'
        success: (data) ->
          if not data.ok
            $('#login_error').html('Database sign-in failed.')
            return
          next()

      $('#login_error').html('Signing you into the database.')
      $.ajax(couchdb_options)

    login_done = ->
      # All done.
      $('#login_error').html('')
      $('#login').dialog('close')
      window.location.reload()

    $('#login_container').load '/u/login.widget', ->
      $('form.main').addClass('ui-widget-content')
      $('form.validate').validate()
      $('button,input[type="submit"],input[type="reset"]').button()

      $('#login').submit ->
        if $.extra_login
          main_login -> couchdb_login -> $.extra_login -> login_done()
        else
          main_login -> couchdb_login -> login_done()
        return false

      $('#logout').submit ->
        ajax_options =
          url: '/u/logout.json'
          success: (data) ->
            if data.ok
              window.location.reload()
        $.ajax(ajax_options)
        return false

get '/login.widget': -> widget 'login_widget'

view login_widget: ->

  div id: 'login_buttons', ->
    if @session.logged_in?
      form id: 'logout', ->
        input type: 'submit', value: 'Logout'
    else

      form id: 'login', class: 'main validate', title: 'Sign in', ->
        span id: 'login_error', class: 'error'
        div ->
          label for: 'login_username', -> 'Username'
          input id: 'login_username', class: 'required'
        div ->
          label for: 'login_password', -> 'Password'
          input type: 'password', id: 'login_password', class: 'required'
        div ->
        input type: 'submit', value: 'Sign in'

post '/login.json': ->
  if not @username?
    return send {error:'Missing username'}
  if not @password?
    return send {error:'Missing password'}

  uri = url.parse config.login.session_couchdb_uri
  uri.auth = "#{querystring.escape @username}:#{querystring.escape @password}"
  delete uri.href
  delete uri.host
  session_cdb = cdb.new url.format uri
  session_cdb.get '', (p) =>
    if p.error?
      return send p
    session.logged_in = p.userCtx.name
    session.roles     = p.userCtx.roles
    return send ok:true

get '/logout.json': ->
  delete session.logged_in
  return send ok:true

