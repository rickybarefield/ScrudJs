WebSocketClient = require('websocket').client

class WebSocket

  constructor: (uri) ->

    self = this
    @socket = new WebSocketClient()

    doOpen = (connection) ->

      handleMessage = (message) ->


        if(@onmessage? && message.type == 'utf8')

          compliantMessage =
            data: message.utf8Data

          @onmessage.call(this, compliantMessage)
        else console.log("onmessage was not defined so could not be called")

      self.connection = connection
      if(self.onopen?) then self.onopen.call(arguments) else console.log("onopen was not defined so could not be called")
      connection.on 'message', => handleMessage.apply(this, arguments)
      connection.on 'close', => if(@onclose?) then @onclose.apply(this, arguments) else console.log("onclose was not defined so could not be called")

    @socket.on 'connect', => doOpen.apply(self, arguments)
    @socket.connect(uri)

  send: (message) =>

    @connection.sendUTF(message)

global.WebSocket = WebSocket