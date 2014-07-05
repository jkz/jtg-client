angular.module 'jtg'

.service 'Twitter', (Provider) ->
  Twitter = new Provider 'Twitter'
  Twitter.creds = ->
  Twitter.disconnect = ->
  Twitter
