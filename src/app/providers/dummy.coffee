angular.module 'jtg'

.service 'Dummy', (Provider, facebook) ->
  dummy = new Provider 'Dummy'

  facebook.connect = ->
    facebook.login()

  facebook.on 'auth.login', ->
    Provider.connect.call facebook, token: facebook.session.token
