angular.module 'jtg'

.service 'Facebook', (Provider, facebook) ->
  facebook = new Provider 'Facebook'

  facebook.connect = ->
    facebook.login()

  facebook.on 'auth.login', ->
    Provider.connect.call facebook, token: facebook.session.token
