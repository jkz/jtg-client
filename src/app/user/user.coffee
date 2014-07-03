angular.module 'jtg'

.service 'User', (jtg, Account, Provider) ->
  User = jtg.model 'users'

  User::init = ->
    for provider, data of @accounts
      data.provider = Provider.cache[provider]
      @accounts[provider] = new Account data

  User