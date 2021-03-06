// Generated by CoffeeScript 1.3.3
(function() {
  var Create, Scrud, Subscribe,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Create = require("./ScrudCreate");

  Subscribe = require("./ScrudSubscribe");

  module.exports = Scrud = (function() {
    var generateClientId, receiveMessage;

    generateClientId = function() {
      this.currentClientId++;
      return "cId-" + this.currentClientId;
    };

    function Scrud(websocketAddress) {
      var GenerateProxyConstructor, self;
      this.websocketAddress = websocketAddress;
      this.send = __bind(this.send, this);

      this.connect = __bind(this.connect, this);

      self = this;
      this.clientIdMap = {};
      this.currentClientId = 1;
      GenerateProxyConstructor = function(Type) {
        var func;
        func = function() {
          var clientId;
          Type.apply(this, arguments);
          this.Scrud = self;
          clientId = generateClientId.call(self);
          this.clientId = clientId;
          self.clientIdMap[clientId] = this;
          return this;
        };
        func.prototype = Type.prototype;
        return func;
      };
      this.Create = GenerateProxyConstructor(Create);
      this.Subscribe = GenerateProxyConstructor(Subscribe);
    }

    receiveMessage = function(message) {
      var json, messagesClientId;
      json = JSON.parse(message.data);
      messagesClientId = json['client-id'];
      return this.clientIdMap[messagesClientId][json['message-type']](json);
    };

    Scrud.prototype.connect = function(onOpenCallback) {
      var self;
      self = this;
      this.websocket = new WebSocket(this.websocketAddress);
      this.websocket.onopen = onOpenCallback;
      return this.websocket.onmessage = function() {
        return receiveMessage.apply(self, arguments);
      };
    };

    Scrud.prototype.send = function(object) {
      return this.websocket.send(JSON.stringify(object));
    };

    return Scrud;

  })();

}).call(this);
