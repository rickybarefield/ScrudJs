Create = require("./ScrudCreate")

module.exports = class Scrud

  constructor: (@websocketAddress) ->

  connect: ->

    @websocket = new WebSocket(@websocketAddress)

  Create: =>

    createMessage = new Create(arguments)
    createMessage.Scrud = @
    createMessage

  send: (object) ->

    @websocket.send(JSON.stringify(object))