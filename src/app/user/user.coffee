angular.module 'jtg.api'

.factory 'orderedHash', ->
  (array, {key}={}) ->
    key ?= (elem) -> elem.id

    Object.defineProperty array, 'insert', get: ->
      (element, index) ->
        index ?= array.length
        array.splice(index, 0, element)
        array[key(element)] = element

    Object.defineProperty array, 'removeIndex', get: ->
      (index) ->
        console.log {index}
        throw "Existsn't" unless 0 <= index < array.length
        element = array[index]
        array.splice(index, 1) if index > -1
        delete array[key(element)]

    Object.defineProperty array, 'removeKey', get: ->
      (key) ->
        console.log {key}
        throw "Existsn't" unless array[key]
        index = array.indexOf(array[key])
        array.removeIndex(index)

    Object.defineProperty array, 'remove', get: ->
      (element) ->
        console.log {element}
        array.removeKey(key(element))

.service 'User', (jtg, Account, Provider, hub, toast, orderedHash) ->
  User = jtg.model 'users'

  User::init = ->
    _accounts = @accounts
    @accounts = orderedHash [], key: (elem) -> elem.provider.slug
    @accounts.insert Account.build account for account in _accounts
    console.log @accounts

    # for account, index in @accounts ? []
    #   @accounts[index] = @accounts[account.provider] = Account.build account

    Account.emitter.on 'connect', @accounts.insert
    Account.emitter.on 'disconnect', @accounts.remove

    Object.defineProperty this, 'mention_name',
      get: =>
        if @current then 'You' else @name

    hub.users.emit 'join', uid: @id

    @on 'transaction', ({balance, value, data, ref}) =>
      # this.points = balance
      @points += value
      toast.create """
        #{@mention_name} #{if value > 0 then 'earned' else 'lost'} #{Math.abs(value)} points for #{ref}!
      """
    @on 'login', =>
      @online = true
      toast.create """
        #{@mention_name} logged in.
      """
    @on 'logout', =>
      @online = false
      toast.create """
        #{@mention_name} logged out.
      """

  User::addAccount = Account.connect

  User.me = ->
    jtg
      .get "/me"
      .then ({data}) =>
        @build data[@singular]

  hub.users.on 'data', ({uid, type, data}) ->
    user = User.cache[uid]?.emit type, data

  User
