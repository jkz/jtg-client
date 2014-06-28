angular.module 'jtg'

.factory 'Account', (jtg, Provider) ->
  Account = jtg.model 'accounts'

  Account::init = ->
    @provider = Provider.cache @provider

  Account::disconnect = Account::destroy

.controller 'AccountCtrl', ($scope, session, Provider) ->
  $scope.providers = Provider.cache
  # $scope.accounts = session.user.accounts

.directive 'account', ->
  restrict: 'E'
  templateUrl: 'app/account/account.html'
