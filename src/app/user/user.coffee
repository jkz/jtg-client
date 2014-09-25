angular.module 'jtg.api'

.service 'User', (jtg, Account, Provider, hub, toast) ->
  User = jtg.model 'users'

  User::init = ->
    for account in @accounts ? []
      @accounts[account.provider] = Account.build account

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
