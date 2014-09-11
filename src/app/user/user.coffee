angular.module 'jtg'

.service 'User', (jtg, Account, Provider, hub, toast) ->
  User = jtg.model 'users'

  User::init = ->
    for account in @accounts ? []
      @accounts[account.provider] = new Account account

    Object.defineProperty this, 'mentionName',
      get: =>
        if @current then 'You' else @name

    # @hub = hub.users.for(@id)
    console.log """

    Connection to /users namespace
    hub.users.emit 'join', uid: #{@id}

    """
    hub.users.emit 'join', uid: @id

    @on 'transaction', ({balance, value, data, ref}) =>
      # this.points = balance
      @points += value
      console.log "TRANSACTION", points: @points
      toast.create """
        #{@mentionName} #{if value > 0 then 'earned' else 'lost'} #{Math.abs(value)} points for #{ref}!
      """
    @on 'login', =>
      @online = true
      toast.create """
        #{@mentionName} logged in.
      """
    @on 'logout', =>
      @online = false
      toast.create """
        #{@mentionName} logged out.
      """

  hub.users.on 'data', ({uid, type, data}) ->
    console.log "USER", {uid, type, data}
    user = User.cache[uid]?.emit type, data

  User
