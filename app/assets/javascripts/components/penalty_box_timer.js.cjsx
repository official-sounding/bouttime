cx = React.addons.classSet
exports = exports ? this
exports.PenaltyBoxTimer = React.createClass
  componentDidMount: () ->
    $dom = $(this.getDOMNode())
  getInitialState: () ->
    exports.wftda.functions.camelize(this.props)
  render: () ->
    <div className="penalty-box-timer"></div>