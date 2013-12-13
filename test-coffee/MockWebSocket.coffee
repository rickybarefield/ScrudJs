class MockWebSocket

  constructor: (uri) ->

    MockWebSocket.lastCreated = this

  send: (message) => @lastMessageSent = message

  receive: (message) => if(@.onmessage) then @.onmessage.call(@, message)

module.exports = MockWebSocket
global.WebSocket = MockWebSocket