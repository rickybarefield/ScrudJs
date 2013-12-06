class MockWebSocket

  constructor: (uri) ->

    MockWebSocket.lastCreated = this

  send: (message) => @lastMessageSent = message

module.exports = MockWebSocket
global.WebSocket = MockWebSocket