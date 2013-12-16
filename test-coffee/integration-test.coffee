
Scrud = require("./Scrud")
require("./BrowserWebSocketEmulator")
global.scrud = new Scrud("ws://localhost:8080/scrud-java-server-integration-test-0.0.1-SNAPSHOT/websocket")

global.receivedMessages = []

subscribe = ->

  handleMessage = (message) ->
    console.log("received message")
    receivedMessages.push message

  global.subscriptionMessage = new scrud.Subscribe("Item")
  subscriptionMessage.send handleMessage, handleMessage

scrud.connect(subscribe)


