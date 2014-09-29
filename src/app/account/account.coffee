angular.module 'jtg'

# ## Account
# ---
# An account is a provider/uid combination which ties
# User objects to providers and enables login.
.service 'Account', (omniauth, jtg, Provider) ->
  # TODO
  # Yugh, this seems superugly. We might want some support in
  # rest.api for nested resources...
  Account = jtg.model 'accounts', endpoint: '/me/accounts'

  Account.providers = []

  Account::init = ->
    # WARNING
    # this replaces the provider attribute and could
    # result in unexpected behaviour
    @provider = Provider.cache[@provider]

    # WARNING
    # The user gets magically set by the parent

  Account.connect = (provider) ->
    omniauth.authenticate(provider)
      .then Account.create
      .then (response) ->
        Account.show provider
          .then (account) ->
            Account.emitter.emit 'connect', account

  Account::disconnect = ->
    Account
      .destroy @provider.slug
      .then =>
        Account.emitter.emit 'disconnect', this

  Account

.controller 'AccountCtrl', ($scope, Account) ->
  $scope.Account = Account

.directive 'account', ->
  restrict: 'E'
  templateUrl: 'app/account/account.html'
