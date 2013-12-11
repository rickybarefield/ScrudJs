Create = require("./ScrudCreate")

module.exports = class Scrud

  constructor: (@websocketAddress) ->

    self = this
    @Create = ->
      Create.apply(this, arguments)
      this.Scrud = self
      this

    @Create.prototype = Create.prototype


  connect: ->

    @websocket = new WebSocket(@websocketAddress)

  send: (object) ->

    @websocket.send(JSON.stringify(object))