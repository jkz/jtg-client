describe 'rest', ->
  describe 'Api', ->
    Api = $location = $scope = undefined

    beforeEach module 'rest'

    beforeEach inject ($controller, _$location_, $rootScope) ->
      $location = _$location_
      $scope = $rootScope.$new()
      Api = $controller 'Api', {$location, $scope}

    it 'should pass a dummy test', inject ->
      expect(Api).toBeTruthy()
