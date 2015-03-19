cx = React.addons.classSet
exports = exports ? this

exports.PassItem = React.createClass
  displayName: 'PassItem'
  propType:
    passState: React.PropTypes.object.isRequired
    actions: React.PropTypes.object.isRequired
    lastPass: React.PropTypes.boolean

  decrementPassNumber: () ->
    passNumber = this.props.passState.passNumber
    if passNumber > 1
      this.props.actions.setPassNumber(passNumber - 1)

  incrementPassNumber: () ->
    passNumber = this.props.passState.passNumber
    this.props.actions.setPassNumber(passNumber + 1)

  getNotes: () ->
    pass = this.props.passState
    flags =
      injury: pass.injury
      nopass: pass.nopass
      calloff: pass.calloff
      lost: pass.lostLead
      lead: pass.lead

    Object.keys(flags).filter (key) ->
      flags[key]

  render: () ->
    injuryClass = cx
      'selected': this.props.passState.injury
      'notes': true
      'injury': true
      'text-center': true

    callClass = cx
      'selected': this.props.passState.calloff
      'notes': true
      'call': true
      'text-center': true

    lostClass = cx
      'selected': this.props.passState.lostLead
      'notes': true
      'lost': true
      'text-center': true

    editPassNumberId = "edit-pass-number#{exports.wftda.functions.uniqueId()}"
    editPassId = "edit-pass-#{exports.wftda.functions.uniqueId()}"

    notes = this.getNotes()

    <div aria-multiselectable="true">
      <div className="columns">
        <div className="row gutters-xs">
          <div className="col-sm-2 col-xs-2">
            <button className="pass btn btn-block" data-toggle="collapse" data-target={"##{editPassNumberId}"} aria-expanded="false" aria-controls={editPassNumberId} >
              {this.props.passState.passNumber}
            </button>
          </div>
          <div className="col-sm-2 col-xs-2">
            <button className="skater btn btn-block">
              <span className="glyphicon glyphicon-chevron-down" aria-hidden="true"></span>              
            </button>
          </div>
          <div data-toggle="collapse" data-target={"##{editPassId}"} aria-expanded="false" aria-controls={editPassId}>
            <div className="col-sm-2 col-xs-2">
              <ScoreNote note={notes[0]} />
            </div>
            <div className="col-sm-2 col-xs-2">
              <ScoreNote note={notes[1]} />
            </div>
            <div className="col-sm-2 col-xs-2">
              <ScoreNote note={notes[2]} />
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="points boxed-good text-center">
                <strong>{this.props.passState.points || 0}</strong>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className="panel">
        <div className="edit-pass-number collapse" id={editPassNumberId}>
          <div className="row gutters-xs">
            <div className="col-sm-1 col-xs-1">
              <button className="remove btn btn-block"  data-toggle='collapse' data-target={"##{editPassNumberId}"}>
                <span aria-hidden="true" className="glyphicon glyphicon-remove"></span>
              </button>
            </div>
            <div className="col-sm-2 col-xs-2">
              <button className="minus btn btn-block" onClick={this.decrementPassNumber}>
                <span aria-hidden="true" className="glyphicon glyphicon-minus"></span>
              </button>
            </div>
            <div className="col-sm-2 col-xs-2">
              <button className="plus btn btn-block" onClick={this.incrementPassNumber}>
                <span aria-hidden="true" className="glyphicon glyphicon-plus"></span>
              </button>
            </div>
            <div className="col-sm-1 col-xs-1">
              <button className="ok btn btn-block" onClick={this.props.nextPass} data-toggle='collapse' data-target={"##{editPassNumberId}"}>
                <span aria-hidden="true" className="glyphicon glyphicon-ok"></span>
              </button>
            </div>
          </div>
        </div>
      </div>
      <PassEditPanel {...this.props} editPassId={editPassId}/>
    </div>