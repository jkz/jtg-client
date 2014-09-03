angular.module 'github', []

.service 'github', ($http) ->
  api = (url, params, status, error) ->
    $http
      method: 'GET'
      url: 'https://api.github.com' + url
      params: params

  commits: (name, repo, params) ->
      url = "/repos/#{name}/#{repo}/commits"
      api(url, params)
        .success (data, status, headers, config) ->
            console.log 'commits success', data
        .error (data, status, headers, config) ->
            console.log 'commits success', data

  repos: (name, params) ->
      url = "/repos/#{name}"
      api(url, params)

  activities: (name, params) ->
    url = "/users/#{name}/events"
    api(url, params)

.directive 'githubActivities', (github) ->
  restrict: 'AE'
  scope:
    user: '='
  templateUrl: 'github/activities.tpl.html'
  link: ($scope) ->
      console.log(github)
      github.activities($scope.user).success (data) ->
          $scope.activities = data.slice(0, 10)
