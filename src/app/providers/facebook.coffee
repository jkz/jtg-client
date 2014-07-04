angular.module 'jtg'

.service 'Facebook', (resolve, Provider, facebook) ->
  Facebook = new Provider 'Facebook'
  Facebook.creds = ->
    facebook
      .login()
      .then ({accessToken}) ->
        token: accessToken

  Facebook.disconnect = facebook.logout
  Facebook
