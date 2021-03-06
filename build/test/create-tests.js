// Generated by CoffeeScript 1.3.3
(function() {
  var MockWebSocket, Scrud, assert, expect, mockWebSocket, scrudConnection, sinon;

  expect = require("./expect.js");

  sinon = require("sinon");

  Scrud = require("Scrud");

  MockWebSocket = require("./MockWebSocket.js");

  assert = new expect.Assertion;

  scrudConnection = new Scrud("ws://localhost:8080/websocket");

  scrudConnection.connect();

  mockWebSocket = MockWebSocket.lastCreated;

  suite('Create', function() {
    var createWsMessage;
    createWsMessage = function(payload) {
      var message;
      return message = {
        'data': payload
      };
    };
    test('correct JSON is produced', function() {
      var createMessage, jsonSent, resource, resourceType;
      scrudConnection.currentClientId = 0;
      resourceType = "Item";
      resource = {
        name: 'MyItem'
      };
      createMessage = new scrudConnection.Create(resourceType, resource);
      createMessage.send(function() {
        var success;
        return success = true;
      });
      jsonSent = mockWebSocket.lastMessageSent;
      return expect(jsonSent).to.equal('{"message-type":"create","client-id":"cId-1","resource-type":"Item","resource":{"name":"MyItem"}}');
    });
    test('onSuccess function should be called', function() {
      var clientId, createMessage, resource, success, type;
      type = "Item";
      resource = {
        name: 'MyItem'
      };
      success = false;
      createMessage = new scrudConnection.Create(type, resource);
      clientId = createMessage.clientId;
      createMessage.send(function() {
        return success = true;
      });
      mockWebSocket.receive(createWsMessage("{\"client-id\": \"" + clientId + "\", \"message-type\": \"create-success\"}"));
      return expect(success).to.equal(true);
    });
    return test('A ScrudSuccess message should be passed to the onSuccess function', function() {
      var clientId, createMessage, doSuccess, resource, success, type;
      type = "Item";
      resource = {
        name: 'MyItem'
      };
      success = false;
      doSuccess = function(createSuccessMessage) {
        success = true;
        expect(createSuccessMessage.resource.name).to.equal("MyItem");
        expect(createSuccessMessage.resource.id).to.equal("server-id-1");
        return expect(createSuccessMessage.resourceId).to.equal("server-id-1");
      };
      createMessage = new scrudConnection.Create(type, resource);
      clientId = createMessage.clientId;
      createMessage.send(doSuccess);
      mockWebSocket.receive(createWsMessage("{\"client-id\": \"" + clientId + "\", \"message-type\": \"create-success\", \"resource-id\": \"server-id-1\", \"resource\": {\"name\": \"MyItem\", \"id\": \"server-id-1\"}}"));
      return expect(success).to.equal(true);
    });
  });

}).call(this);
