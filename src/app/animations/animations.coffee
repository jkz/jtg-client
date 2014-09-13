angular.module 'jtg'

.run ($window, $rootScope) ->
  $win = angular.element($window)

  do updateScrollAtIntro = ->
    scrollTop = $win.scrollTop()
    switch
      when scrollTop > 300 and $rootScope.scrollAtIntro
        $rootScope.scrollAtIntro = false
      when scrollTop <= 300 and not $rootScope.scrollAtIntro
        $rootScope.scrollAtIntro = true
      else
        return
    $rootScope.$apply()

  $win.on 'scroll', updateScrollAtIntro
