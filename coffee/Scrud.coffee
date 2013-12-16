Create = require("./ScrudCreate")
Subscribe = require("./ScrudSubscribe")

module.exports = class Scrud

  generateClientId = ->

    @currentClientId++
    "cId-" + @currentClientId

  constructor: (@websocketAddress) ->

    self = this
    @clientIdMap = {}
    @currentClientId = 1

    GenerateProxyConstructor = (Type) ->
      func = ->
        Type.apply(this, arguments)
        this.Scrud = self
        clientId = generateClientId.call(self)
        this.clientId = clientId
        self.clientIdMap[clientId] = this
        this
      func.prototype = Type.prototype
      return func

    @Create = GenerateProxyConstructor(Create)
    @Subscribe = GenerateProxyConstructor(Subscribe)

  receiveMessage = (message) ->
    json = JSON.parse(message)
    messagesClientId = json['client-id']
    @clientIdMap[messagesClientId][json['message-type']](json)

  connect: (onOpenCallback) =>

    self = this
    @websocket = new WebSocket(@websocketAddress)
    @websocket.onopen = onOpenCallback
    @websocket.onmessage = -> receiveMessage.apply(self, arguments)

  send: (object) =>

    @websocket.send(JSON.stringify(object))