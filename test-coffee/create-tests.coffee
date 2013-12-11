expect = require("./expect.js")
sinon = require("sinon")
Scrud = require("./Scrud.js")
MockWebSocket = require("./MockWebSocket.js")
assert = new expect.Assertion

scrudConnection = new Scrud("http://localhost:8080/websocket")
scrudConnection.connect()
mockWebSocket = MockWebSocket.lastCreated

suite 'Create', ->

test 'correct JSON is produced', ->

  clientId = "myClientId"
  type = "Item"

  resource =
    name: 'MyItem'

  createMessage = new scrudConnection.Create(clientId, type, resource, -> success = true)

  createMessage.send()

  jsonSent = mockWebSocket.lastMessageSent

  expect(jsonSent).to.equal '{"client-id":"myClientId","type":"Item","resource":{"name":"MyItem"}}'

test 'onSuccess function should be called', ->

  clientId = "myClientId"
  type = "Item"

  resource =
    name: 'MyItem'

  success = false

  createMessage = new scrudConnection.Create(clientId, type, resource, -> success = true)

  expect(success).to.equal true
