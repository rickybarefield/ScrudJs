WebSocketClient = require('websocket').client

class WebSocket

  constructor: (uri) ->

    self = this
    @socket = new WebSocketClient()

    doOpen = (connection) ->
      if(self.onopen?) then self.onopen.call(arguments) else console.log("onopen was not defined so could not be called")
      self.connection = connection

    @socket.on 'connect', => doOpen.apply(this, arguments)
    @socket.on 'message', => if(@onmessage?) then @onmessage.call(arguments) else console.log("onmessage was not defined so could not be called")
    @socket.on 'close', => if(@onclose?) then @onclose.call(arguments) else console.log("onclose was not defined so could not be called")
    @socket.connect(uri)

  send: (message) =>

    @connection.sendUTF(message)

global.WebSocket = WebSocket