angular.module 'jtg'

# ## Provider
# ---
# Just there to provide the means to obtain creds
# to connect an account to a user, or create a new.
# .service 'Provider', (auth, Account) ->
#   class Provider
#     constructor: (name, slug) ->
#       @slug ?= name.toLowerCase()
#       Account.providers[@slug] = @

#     connect: (creds) ->
#       auth.connect @slug, creds


# ## Account
# ---
# An account is a provider/uid combination which ties
# User objects to providers and enables login.
.service 'Account', (jtg) ->
  Account = jtg.model 'accounts'

  # Providers are autoregistered on the account model
  # TODO this seems slightly tangled up, we might want to
  # swap the dependency
  Account.providers = {}

  Account::init = ->
    # TODO this replaces the provider attribute and could
    # result in unexpected behaviour
    @provider = Account.providers @provider

  # Rename for aesthetic/symmetric purposes
  Account::disconnect = Account::destroy

  Account

.controller 'AccountCtrl', ($scope, Account) ->
  $scope.providers = Account.providers

# .directive 'provider', ->
#   restrict: 'E'
#   templateUrl: 'app/provider/provider.html'

.directive 'account', ->
  restrict: 'E'
  templateUrl: 'app/account/account.html'
