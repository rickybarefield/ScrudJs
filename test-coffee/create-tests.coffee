expect = require("./expect.js")
sinon = require("sinon")
Scrud = require("./Scrud.js")
MockWebSocket = require("./MockWebSocket.js")
assert = new expect.Assertion

scrudConnection = new Scrud("ws://localhost:8080/websocket")
scrudConnection.connect()
mockWebSocket = MockWebSocket.lastCreated

suite 'Create', ->

test 'correct JSON is produced', ->

  scrudConnection.currentClientId = 0
  type = "Item"

  resource =
    name: 'MyItem'

  createMessage = new scrudConnection.Create(type, resource, -> success = true)

  createMessage.send()

  jsonSent = mockWebSocket.lastMessageSent

  expect(jsonSent).to.equal '{"client-id":"cId-1","type":"Item","resource":{"name":"MyItem"}}'

test 'onSuccess function should be called', ->

  type = "Item"

  resource =
    name: 'MyItem'

  success = false

  createMessage = new scrudConnection.Create(type, resource, -> success = true)
  clientId = createMessage.clientId
  createMessage.send()

  mockWebSocket.receive("""{"client-id": "#{clientId}", "message-type": "create-success"}""")

  expect(success).to.equal true
