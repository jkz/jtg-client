angular.module 'jtg'

.service 'User', (jtg, session) ->
  jtg.model 'users'
