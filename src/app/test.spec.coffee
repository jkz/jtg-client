describe 'AppCtrl', ->
  describe 'isCurrentUrl', ->
    AppCtrl = $location = $scope = undefined

    beforeEach module 'jtg'

    beforeEach inject ($controller, _$location_, $rootScope) ->
      $location = _$location_
      $scope = $rootScope.$new()
      AppCtrl = $controller 'AppCtrl', {$location: $location, $scope: $scope}

    it 'should pass a dummy test', inject ->
      expect(AppCtrl).toBeTruthy()
