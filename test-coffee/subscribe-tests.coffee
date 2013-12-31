expect = require("./expect.js")
sinon = require("sinon")
Scrud = require("Scrud")
MockWebSocket = require("./MockWebSocket.js")
assert = new expect.Assertion

scrudConnection = new Scrud("ws://localhost:8080/websocket")
scrudConnection.connect()
mockWebSocket = MockWebSocket.lastCreated

suite 'Subscribe', ->

  test 'Correct JSON is produced', ->

    scrudConnection.currentClientId = 0

    resourceType = "Item"

    subscribeMessage = new scrudConnection.Subscribe(resourceType)

    subscribeMessage.send()

    jsonSent = mockWebSocket.lastMessageSent

    expect(jsonSent).to.equal '{"message-type":"subscribe","client-id":"cId-1","resource-type":"Item"}'


  test 'A ScrudSubscriptionSuccess message should be passed to the onSuccess function', ->

    success = false

    scrudConnection.currentClientId = 100


    doSuccess = (successMessage) ->

      success = true
      successMessage.resources.id1 = {"name":"Bob"}
      successMessage.resources.id2 = {"name":"Sandy"}

    subscribeMessage = new scrudConnection.Subscribe("Item")
    subscribeMessage.send(doSuccess)

    mockWebSocket.receive("""{"client-id": "cId-101", "message-type": "subscription-success", "resources": {"id1":{"name":"Bob"}, "id2":{"name":"Sandy"}}}""")

    expect(success).to.equal true

  test 'A ScrudCreated messages should be passed to the onResourceCreated function', ->

    called = false

    scrudConnection.currentClientId = 101

    onResourceCreated = (createMessage) ->

      called = true
      expect(createMessage.resource.name).to.equal "Matilda"
      expect(createMessage.resource.id).to.equal "M1"
      expect(createMessage.resourceId).to.equal "S-M1"

    subscribeMessage = new scrudConnection.Subscribe("Item")

    subscribeMessage.send(null, onResourceCreated)

    mockWebSocket.receive("""{"client-id": "cId-102", "message-type": "created", "resource": {"name":"Matilda", "id":"M1"}, "resource-id":"S-M1"}""")
