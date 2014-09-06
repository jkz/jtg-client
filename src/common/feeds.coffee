angular.module 'feeds', [
  'socket.io'
]

# feeds
# ---
# Hook up to a socket feed ('feeds' on npm)
# and expose an array that is edited in place.
.provider 'feeds', ->
  @config =
    host: '/feeds'

  @$get = (io) =>
    feeds = (name, host) =>
      return feeds[name] if feeds[name]?

      host ?= @config.host
      url = "#{host}/#{name}"

      console.log {url}

      entries = []
      socket = io.connect url

      console.log {socket}

      socket.on "history", (history) ->
        console.log name, {history}
        entries.push entry for entry in history

      socket.on "entry", (entry) ->
        console.log name, {entry}
        entries.unshift entry

      remove = socket.on 'ready', ->
        remove()
        socket.emit "init"

      feeds[name] = {socket, entries}

  this
