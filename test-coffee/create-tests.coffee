expect = require("./expect.js")
sinon = require("sinon")
Scrud = require("Scrud")
MockWebSocket = require("./MockWebSocket.js")
assert = new expect.Assertion

scrudConnection = new Scrud("ws://localhost:8080/websocket")
scrudConnection.connect()
mockWebSocket = MockWebSocket.lastCreated

suite 'Create', ->

  createWsMessage = (payload) ->

    message =
      'data': payload

  test 'correct JSON is produced', ->

    scrudConnection.currentClientId = 0
    resourceType = "Item"

    resource =
      name: 'MyItem'

    createMessage = new scrudConnection.Create(resourceType, resource)

    createMessage.send(-> success = true)

    jsonSent = mockWebSocket.lastMessageSent

    expect(jsonSent).to.equal '{"message-type":"create","client-id":"cId-1","resource-type":"Item","resource":{"name":"MyItem"}}'

  test 'onSuccess function should be called', ->

    type = "Item"

    resource =
      name: 'MyItem'

    success = false

    createMessage = new scrudConnection.Create(type, resource)
    clientId = createMessage.clientId
    createMessage.send(-> success = true)

    mockWebSocket.receive(createWsMessage("""{"client-id": "#{clientId}", "message-type": "create-success"}"""))

    expect(success).to.equal true

  test 'A ScrudSuccess message should be passed to the onSuccess function', ->

    type = "Item"

    resource =
      name: 'MyItem'

    success = false

    doSuccess = (createSuccessMessage) ->

      success = true
      expect(createSuccessMessage.resource.name).to.equal "MyItem"
      expect(createSuccessMessage.resource.id).to.equal "server-id-1"
      expect(createSuccessMessage.resourceId).to.equal "server-id-1"


    createMessage = new scrudConnection.Create(type, resource)
    clientId = createMessage.clientId
    createMessage.send(doSuccess)


    mockWebSocket.receive(createWsMessage("""{"client-id": "#{clientId}", "message-type": "create-success", "resource-id": "server-id-1", "resource": {"name": "MyItem", "id": "server-id-1"}}"""))

    expect(success).to.equal true
