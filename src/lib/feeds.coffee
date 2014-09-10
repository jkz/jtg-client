angular.module 'feeds', [
  'socket.io'
]

# feeds
# ---
# Hook up to a socket feed (https://www.npmjs.org/package/feeds)
# and expose an array that is edited in place.
.provider 'feeds', ->
  @config =
    host: ''

  @$get = (io) =>
    feeds = (key, host) =>
      return feeds[key] if feeds[key]?

      host ?= @config.host
      url = "#{host}#{key}"

      entries = []
      socket = io.connect url

      socket.on "history", (history) ->
        entries.push entry for entry in history

      socket.on "data", (data) ->
        entries.unshift data

      remove = socket.on 'ready', ->
        remove()
        socket.emit "init"

      feeds[key] = {socket, entries}

    feeds

  this
