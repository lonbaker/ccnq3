# (c) 2012 Stephane Alnet
#
{exec,spawn} = require('child_process')
fs = require 'fs'
byline = require 'byline'
events = require 'events'

minutes = 60*1000 # milliseconds

## Fields returned in the "JSON" response.
# An additional field "intf" indicates on which interface
# the packet was captured.
trace_field_names = [
  "frame.time"
  "ip.version"
  "ip.dsfield.dscp"
  "ip.src"
  "ip.dst"
  "ip.proto"
  "udp.srcport"
  "udp.dstport"
  "tcp.srcport"
  "tcp.dstport"
  "sip.Call-ID"
  "sip.Request-Line"
  "sip.Method"
  "sip.r-uri.user"
  "sip.r-uri.host"
  "sip.r-uri.port"
  "sip.Status-Line"
  "sip.Status-Code"
  "sip.to.user"
  "sip.from.user"
  "sip.From"
  "sip.To"
  "sip.contact.addr"
  "sip.User-Agent"
]

tshark_fields = []
for f in trace_field_names
  tshark_fields.push '-e'
  tshark_fields.push f

tshark_line_parser = (t) ->
  return if not t?
  t.trimRight()
  values = t.split /\t/
  result = {}
  for value, i in values
    do (value,i) ->
      return unless value? and value isnt ''
      value.replace /\\"/g, '"' # tshark escapes " into \"
      result[trace_field_names[i]] = value
  return result

# Options are:
#   interface
#   trace_dir
#   find_filter
#   ngrep_filter
#   tshark_filter
#   pcap          if provided, a PCAP filename
#
# Returned object is an EventEmitter;
# it will trigger three event types:
#   .on 'data', (data) ->
#   .on 'end', () ->
#   .on 'close', () ->

module.exports = (options) ->

  self = new events.EventEmitter

  self.end = ->
    was = self._ended
    self._ended = true
    if not was
      self.emit 'end'
    return

  self.close = ->
    self.end()
    was = self._closed
    self._closed = true
    if not was
      self.emit 'close'
    return

  self.pipe = (s) ->
    if self._ended or self._closed
      console.error 'pipe: self already ended or closed'
    if self._pipe
      console.error 'pipe: self already piped'
    self._pipe = s
    self.emit 'pipe', s
    return

  run = (intf) ->

    # We _have_ to use a file because tshark cannot read from a pipe/fifo/stdin.
    # (And we need tshark for its filtering and field selection features.)
    fh = "#{options.trace_dir}/.tmp.cap1.#{Math.random()}"

    ## Generate a merged capture file
    pcap_command = """
      nice find '#{options.trace_dir}' -maxdepth 1 -type f -size +80c \\
        -name '#{intf ? '[a-z]'}*.pcap*' #{options.find_filter ? ''} -print0 |  \\
      nice xargs -0 -r mergecap -F libpcap -w - | \\
      nice ngrep -i -l -q -I - -O '#{fh}' '#{options.ngrep_filter}' >/dev/null
    """

    ## Select the proper packets
    if options.pcap?
      tshark_command = [
        'tshark', '-r', fh, '-R', options.tshark_filter, '-nltad', '-T', 'fields', tshark_fields..., '-P', '-w', options.pcap
      ]
    else
      tshark_command = [
        'tshark', '-r', fh, '-R', options.tshark_filter, '-nltad', '-T', 'fields', tshark_fields...
      ]

    # stream is tshark.stdout
    tshark_pipe = (stream) ->
      linestream = byline stream
      linestream.on 'data', (line) ->
        data = tshark_line_parser line
        data.intf = intf
        self.emit 'data', data
      linestream.on 'end', ->
        self.end()
      linestream.on 'error', ->
        console.log "Linestream error"
        seld.end()

    # Fork the find/mergecap/ngrep pipe.
    pcap = exec pcap_command,
      stdio: ['ignore','ignore','ignore']

    pcap_kill = ->
      pcap.kill()

    pcap_kill_timer = setTimeout pcap_kill, 10*minutes

    # Wait for the pcap_command to terminate.
    pcap.on 'exit', (code) ->
      console.dir on:'exit', code:code, pcap_command:pcap_command
      clearTimeout pcap_kill_timer
      if code isnt 0
        # Remove the temporary (pcap) file
        fs.unlink fh, (err) ->
          if err
            console.dir error:err, when: "unlink #{fh}"
        # The response is complete
        self.close()
        return

      tshark = spawn 'nice', tshark_command,
        stdio: ['ignore','pipe','ignore']

      tshark_kill = ->
        tshark.kill()

      tshark_kill_timer = setTimeout tshark_kill, 10*minutes

      tshark.on 'exit', (code) ->
        console.dir on:'exit', code:code, tshark_command:tshark_command
        clearTimeout tshark_kill_timer
        # Remove the temporary (pcap) file, it's not needed anymore.
        fs.unlink fh, (err) ->
          if err
            console.dir error:err, when: "unlink #{fh}"
        # The response is complete
        self.close()

      tshark_pipe tshark.stdout

  run options.interface

  return self
