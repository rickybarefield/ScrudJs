// Generated by CoffeeScript 1.3.3
(function() {
  var MockWebSocket, Scrud, assert, expect, mockWebSocket, scrudConnection, sinon;

  expect = require("./expect.js");

  sinon = require("sinon");

  Scrud = require("./Scrud.js");

  MockWebSocket = require("./MockWebSocket.js");

  assert = new expect.Assertion;

  scrudConnection = new Scrud("ws://localhost:8080/websocket");

  scrudConnection.connect();

  mockWebSocket = MockWebSocket.lastCreated;

  suite('Subscribe', function() {
    test('Correct JSON is produced', function() {
      var jsonSent, resourceType, subscribeMessage;
      scrudConnection.currentClientId = 0;
      resourceType = "Item";
      subscribeMessage = new scrudConnection.Subscribe(resourceType);
      subscribeMessage.send();
      jsonSent = mockWebSocket.lastMessageSent;
      return expect(jsonSent).to.equal('{"message-type":"subscribe","client-id":"cId-1","resource-type":"Item"}');
    });
    test('A ScrudSubscriptionSuccess message should be passed to the onSuccess function', function() {
      var doSuccess, subscribeMessage, success;
      success = false;
      scrudConnection.currentClientId = 100;
      doSuccess = function(successMessage) {
        success = true;
        successMessage.resources.id1 = {
          "name": "Bob"
        };
        return successMessage.resources.id2 = {
          "name": "Sandy"
        };
      };
      subscribeMessage = new scrudConnection.Subscribe("Item");
      subscribeMessage.send(doSuccess);
      mockWebSocket.receive("{\"client-id\": \"cId-101\", \"message-type\": \"subscription-success\", \"resources\": {\"id1\":{\"name\":\"Bob\"}, \"id2\":{\"name\":\"Sandy\"}}}");
      return expect(success).to.equal(true);
    });
    return test('A ScrudCreated messages should be passed to the onResourceCreated function', function() {
      var called, onResourceCreated, subscribeMessage;
      called = false;
      scrudConnection.currentClientId = 101;
      onResourceCreated = function(createMessage) {
        called = true;
        expect(createMessage.resource.name).to.equal("Matilda");
        expect(createMessage.resource.id).to.equal("M1");
        return expect(createMessage.resourceId).to.equal("S-M1");
      };
      subscribeMessage = new scrudConnection.Subscribe("Item");
      subscribeMessage.send(null, onResourceCreated);
      return mockWebSocket.receive("{\"client-id\": \"cId-102\", \"message-type\": \"created\", \"resource\": {\"name\":\"Matilda\", \"id\":\"M1\"}, \"resource-id\":\"S-M1\"}");
    });
  });

}).call(this);
