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
.service 'Account', (jtg, providers) ->
  Account = jtg.model 'accounts'

  Account.providers = providers

  Account::init = ->
    # TODO this replaces the provider attribute and could
    # result in unexpected behaviour
    @provider = Account.providers[@provider]
    console.log "Account::init", provider: @provider, providers: Account.providers

  # Rename for aesthetic/symmetric purposes
  Account::disconnect = ->
    console.log "Account::disconnect", this, Account.providers
    jtg
      .del "/accounts/#{@provider.slug}"
      .then @provider.disconnect

  Account

.controller 'AccountCtrl', ($scope, Account) ->
  $scope.providers = Account.providers

# .directive 'provider', ->
#   restrict: 'E'
#   templateUrl: 'app/provider/provider.html'

.directive 'account', ->
  restrict: 'E'
  templateUrl: 'app/account/account.html'
