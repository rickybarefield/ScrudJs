Create = require("./ScrudCreate")

module.exports = class Scrud

  generateClientId = ->

    @currentClientId++
    "cId-" + @currentClientId

  constructor: (@websocketAddress) ->

    self = this
    @clientIdMap = {}
    @currentClientId = 1
    @Create = ->
      Create.apply(this, arguments)
      this.Scrud = self
      clientId = generateClientId.call(self)
      this.clientId = clientId
      self.clientIdMap[clientId] = this
      this

    @Create.prototype = Create.prototype

  receiveMessage = (message) ->

    json = JSON.parse(message)
    messagesClientId = json['client-id']
    @clientIdMap[messagesClientId].handle(json)

  connect: =>

    self = this
    @websocket = new WebSocket(@websocketAddress)
    @websocket.onmessage = -> receiveMessage.apply(self, arguments)

  send: (object) ->

    @websocket.send(JSON.stringify(object))