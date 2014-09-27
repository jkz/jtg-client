angular.module 'jtg'

.config ($stateProvider, $urlRouterProvider) ->
  # For any unmatched url, redirect to /state1
  $urlRouterProvider.otherwise '/'

  # Now set up the states
  $stateProvider
    .state 'home',
      url: "/"
      templateUrl: "views/home.html"
    .state 'onboard',
      url: "/tutorial"
      templateUrl: "views/onboard.html"
    .state 'earn',
      url: "/earn"
      templateUrl: "views/earn.html"
    .state 'spend',
      url: "/spend"
      templateUrl: "views/spend.html"
    .state 'challenges',
      url: "/challenges"
      templateUrl: "views/challenges.html"
    .state 'stories',
      url: "/stories"
      templateUrl: "views/stories.html"
    .state 'rewards',
      url: "/rewards"
      templateUrl: "views/rewards.html"
    .state 'accounts',
      url: "/accounts"
      templateUrl: "views/accounts.html"
