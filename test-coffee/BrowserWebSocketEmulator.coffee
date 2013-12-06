WebSocketClient = require('websocket').client

class WebSocket

  constructor: (uri) ->

    @socket = new WebSocketClient()
    @socket.on 'connect', => if(@onopen?) then @onopen.call(arguments) else console.log("onopen was not defined so could not be called")
    @socket.on 'message', => if(@onmessage?) then @onmessage.call(arguments) else console.log("onmessage was not defined so could not be called")
    @socket.on 'close', => if(@onclose?) then @onclose.call(arguments) else console.log("onclose was not defined so could not be called")
    @socket.connect(uri)

global.WebSocket = WebSocket