cx = React.addons.classSet
exports = exports ? this
exports.GameNotes = React.createClass
  componentDidMount: () ->
    $dom = $(this.getDOMNode())
  getInitialState: () ->
    exports.wftda.functions.camelize(this.props)
  render: () ->
    <div className="global-bout-notes"></div>