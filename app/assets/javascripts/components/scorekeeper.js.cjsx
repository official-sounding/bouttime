cx = React.addons.classSet
exports = exports ? this
exports.Scorekeeper = React.createClass
  displayName: 'Scorekeeper'

  componentWillMount: () ->
    this.actions = 
      newJam: (teamType, jam) ->
        team = this.getTeamState(teamType)
        team.jamStates.push(jam)

        if jam.jamNumber > this.state.gameState.jamNumber
          this.state.gameState.jamNumber = jam.jamNumber
        dispatcher.trigger "scorekeeper.new_jam", this.getStandardOptions(teamType: teamType)
        this.setState(this.state)

      newPass: (teamType, jamIndex, pass) ->
        jam = this.getJamState(teamType, jamIndex)
        jam.passStates.push(pass)
        dispatcher.trigger "scorekeeper.new_pass", this.getStandardOptions(teamType: teamType, jamIndex: jamIndex)
        this.setState(this.state)

      toggleInjury: (teamType, jamIndex, passIndex) ->
        pass = this.getPassState(teamType, jamIndex, passIndex)
        pass.injury = !pass.injury
        dispatcher.trigger "scorekeeper.toggle_injury", this.getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        this.setState(this.state)

      toggleNopass: (teamType, jamIndex, passIndex) ->
        pass = this.getPassState(teamType, jamIndex, passIndex)
        pass.nopass = !pass.nopass
        dispatcher.trigger "scorekeeper.toggle_nopass", this.getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        this.setState(this.state)

      toggleCalloff: (teamType, jamIndex, passIndex) ->
        pass = this.getPassState(teamType, jamIndex, passIndex)
        pass.calloff = !pass.calloff
        dispatcher.trigger "scorekeeper.toggle_calloff", this.getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        this.setState(this.state)

      toggleLostLead: (teamType, jamIndex, passIndex) ->
        pass = this.getPassState(teamType, jamIndex, passIndex)
        pass.lostLead = !pass.lostLead
        dispatcher.trigger "scorekeeper.toggle_lost_lead", this.getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        this.setState(this.state)

      toggleLead: (teamType, jamIndex, passIndex) ->
        pass = this.getPassState(teamType, jamIndex, passIndex)
        pass.lead = !pass.lead
        dispatcher.trigger "scorekeeper.toggle_lead", this.getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        this.setState(this.state)

      setPoints: (teamType, jamIndex, passIndex, points) ->
        pass = this.getPassState(teamType, jamIndex, passIndex)
        pass.points = points
        dispatcher.trigger "scorekeeper.set_points", this.getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        this.setState(this.state)

      setPassNumber: (teamType, jamIndex, passIndex, passNumber) ->
        pass = this.getPassState(teamType, jamIndex, passIndex)
        pass.passNumber = passNumber
        dispatcher.trigger "scorekeeper.set_pass_number", this.getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        this.setState(this.state)

  # Display actions
  selectTeam: (teamType) ->
    this.setState(selectedTeam: teamType)

  # Helper functions
  getStandardOptions: (opts = {}) ->
    std_opts =
      time: new Date()
      role: 'Scorekeeper'
      state: this.state.gameState
    $.extend(std_opts, opts)

  getTeamState: (teamType) ->
    switch teamType
      when 'away' then this.state.gameState.awayAttributes
      when 'home' then this.state.gameState.homeAttributes

  getJamState: (teamType, jamIndex) ->
    this.getTeamState(teamType).jamStates[jamIndex]

  getPassState: (teamType, jamIndex, passIndex) ->
    this.getJamState(teamType, jamIndex).passStates[passIndex]

  buildNewJam: (jamNumber) ->
    jamNumber: jamNumber
    passStates: []

  bindActions: (teamType) ->
    Object.keys(this.actions).map((key) ->
      key: key
      value: this.actions[key].bind(this, teamType)
    , this).reduce((actions, action) ->
      actions[action.key] = action.value
      actions
    , {})

  # React callbacks
  getInitialState: () ->
    this.props = exports.wftda.functions.camelize(this.props)
    componentId: exports.wftda.functions.uniqueId()
    gameState: this.props
    selectedTeam: 'away'

  render: () ->
    awayElement = <JamsList 
      jamNumber={this.state.gameState.jamNumber}
      teamState={this.getTeamState('away')}
      actions={this.bindActions('away')} />
    homeElement = <JamsList 
      jamNumber={this.state.gameState.jamNumber}
      teamState={this.getTeamState('home')}
      actions={this.bindActions('home')} />

    <div className="scorekeeper">
      <TeamSelector
        awayAttributes={this.state.gameState.awayAttributes}
        awayElement={awayElement}
        homeAttributes={this.state.gameState.homeAttributes}
        homeElement={homeElement} />
    </div>