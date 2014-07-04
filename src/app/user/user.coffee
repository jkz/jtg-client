angular.module 'jtg'

.service 'User', (jtg, Account, Provider) ->
  User = jtg.model 'users'

  User::init = ->
    for account in @accounts
      @accounts[account.provider] = new Account account

  User