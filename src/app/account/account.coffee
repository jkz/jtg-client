angular.module 'jtg'


# ## Account
# ---
# An account is a provider/uid combination which ties
# User objects to providers and enables login.
.service 'Account', (jtg, Provider) ->
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

  Account.connect = (provider) ->
    jtg.auth.authenticate(provider)
      .then Account.create
      .then (response) ->
        console.log {response}
        Account.get provider

  Account::disconnect = ->
    Account.destroy @provider.slug

  Account

.controller 'AccountCtrl', ($scope, Account) ->
  $scope.Account = Account

.directive 'account', ->
  restrict: 'E'
  templateUrl: 'app/account/account.html'
