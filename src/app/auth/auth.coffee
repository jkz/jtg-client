angular.module 'jtg'

.service 'auth', (jtg, User) ->
  auth =
    identify: ->
      jtg.get '/auth'
        .then ({user}) ->
          session.user = user

    connect: (provider, creds) ->
      jtg.post "/auth/#{provider}", {creds}
        .then ({token}) ->
          jtg.token = token
        .then auth.identify

