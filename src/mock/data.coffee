angular.module 'jtg'
###
.service 'mock', ->
  headers =
    response:
      auth: (headers) ->
        headers['Auth-Token'] == 'xxx'
    request:
      auth:
        'Auth-Token': 'xxx'

  user:
    id: 'id'
    name: 'name'
    avatar: '/images/me.jpg'

  stories: [
    {date: 1, text: 'Story 1'}
    {date: 2, text: 'Story 2'}
    {date: 3, text: 'Story 3'}
  ]

  rewards: [
    {date: 1, text: 'Reward 1', points: 10}
    {date: 2, text: 'Reward 2', points: 20}
  ]


.run ($httpBackend, mock) ->
  $httpBackend
    .when 'POST', '/tokens/facebook',
      token: 'access_token'
    .respond null, mock.request.headers.auth

  $httpBackend
    .when 'POST', '/tokens/twitter',
      token: 'token'
    .respond null, mock.request.headers.auth

  $httpBackend
    .when 'DELETE', '/tokens/facebook', null, mock.request.headers.auth
    .respond null

  $httpBackend
    .when 'DELETE', '/tokens', null, mock.request.headers.auth
    .respond null

  $httpBackend
    .when 'POST', '/accounts/facebook',
      token: 'access_token'
    , mock.request.headers.auth
    .respond null

  $httpBackend
    .when 'GET', '/me', null, mock.request.headers.auth
    .respond mock.users[0]

  $httpBackend
    .when 'GET', '/stories', null
    .respond mock.stories

  $httpBackend
    .when 'GET', '/stories/1', null
    .respond mock.stories[0]

  $httpBackend
    .when 'GET', '/rewards', null, mock.request.headers.auth
    .respond mock.rewards

  $httpBackend
    .when 'GET', '/rewards/1', null, mock.request.headers.auth
    .respond mock.rewards[0]
###
