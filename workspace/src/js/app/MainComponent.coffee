React = require 'React'
{_div, _p, _h2, _textarea, _pre, _button} = require 'hyper'

{runtime} = MetaCoffee = require 'metacoffee/metacoffee'
compiler = (require 'metacoffee/prettyfier') MetaCoffee

module.exports = React.createClass

  getInitialState: ->
    value: ''
    result: ''

  handleChange: (event) ->
    @setState
      value: event.target.value

  _compile: ->
    compiler.compile @state.value, bare: true

  translate: ->
    @setState
      result:
        try
          @_compile()
        catch e
          e.message

  run: ->
    @setState
      result:
        try
          translation = @_compile()
          MetaCoffee.installRuntime window
          eval translation
        catch e
          e.message ? e.toString()

  render: ->
    _div {},
      _h2 'Source'
      _textarea cols: 152, rows: 6, onChange: @handleChange
      _p {},
        _button onClick: @translate, 'Traslate'
        _button onClick: @run, 'Run'
      _h2 'Translation'
      _pre @state.result
