;(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
// Generated by CoffeeScript 1.3.3
(function() {
  var Create, Scrud,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Create = require("./ScrudCreate");

  module.exports = Scrud = (function() {
    var generateClientId, receiveMessage;

    generateClientId = function() {
      this.currentClientId++;
      return "cId-" + this.currentClientId;
    };

    function Scrud(websocketAddress) {
      var self;
      this.websocketAddress = websocketAddress;
      this.connect = __bind(this.connect, this);

      self = this;
      this.clientIdMap = {};
      this.currentClientId = 1;
      this.Create = function() {
        var clientId;
        Create.apply(this, arguments);
        this.Scrud = self;
        clientId = generateClientId.call(self);
        this.clientId = clientId;
        self.clientIdMap[clientId] = this;
        return this;
      };
      this.Create.prototype = Create.prototype;
    }

    receiveMessage = function(message) {
      var json, messagesClientId;
      json = JSON.parse(message);
      messagesClientId = json['client-id'];
      return this.clientIdMap[messagesClientId].handle(json);
    };

    Scrud.prototype.connect = function() {
      var self;
      self = this;
      this.websocket = new WebSocket(this.websocketAddress);
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

},{"./ScrudCreate":2}],2:[function(require,module,exports){
// Generated by CoffeeScript 1.3.3
(function() {
  var ScrudCreate,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  module.exports = ScrudCreate = (function() {

    function ScrudCreate(type, resource, onSuccessFunction) {
      this.type = type;
      this.resource = resource;
      this.onSuccessFunction = onSuccessFunction;
      this.handle = __bind(this.handle, this);

    }

    ScrudCreate.prototype.send = function() {
      var message;
      message = {
        'client-id': this.clientId,
        type: this.type,
        resource: this.resource
      };
      return this.Scrud.send(message);
    };

    ScrudCreate.prototype.handle = function(message) {
      switch (message["message-type"]) {
        case 'create-success':
          return this.onSuccessFunction.apply(this, message);
        default:
          return console.log("Warning a response was received but not of an understood message-type for the given client-id");
      }
    };

    return ScrudCreate;

  })();

}).call(this);

},{}]},{},[1])
;