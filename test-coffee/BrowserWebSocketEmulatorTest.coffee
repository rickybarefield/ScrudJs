expect = require("./expect.js")
require("./BrowserWebSocketEmulator")

websocket = new WebSocket("ws://localhost:8080/scrud-java-server-integration-test-0.0.1-SNAPSHOT/websocket")
websocket.onopen = -> console.log("Connected")



