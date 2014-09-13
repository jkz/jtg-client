angular.module 'jtg'


# ## Account
# ---
# An account is a provider/uid combination which ties
# User objects to providers and enables login.
.service 'Account', (jtg, Provider) ->
  Account = jtg.model 'accounts'

  Account.providers = []

  Account::init = ->
    # WARNING
    # this replaces the provider attribute and could
    # result in unexpected behaviour
    @provider = Provider.cache[@provider]

  Account::disconnect = ->
    Account.destroy @provider.slug

  Account

.controller 'AccountCtrl', ($scope, Account) ->
  $scope.providers = Account.providers

.directive 'account', ->
  restrict: 'E'
  templateUrl: 'app/account/account.html'
