CreateSuccess = require("./ScrudCreateSuccess")

module.exports =  class ScrudCreate

  constructor: (@resourceType, @resource, @onSuccessFunction) ->

  send: ->

    message = {"message-type": "create", "client-id": @clientId, "resource-type": @resourceType, "resource": @resource}

    @Scrud.send(message)

  handle: (message) =>

    switch message["message-type"]

      when 'create-success' then @onSuccessFunction.call(this, new CreateSuccess(message["resource-id"], message["resource"]))

      else console.log("Warning a response was received but not of an understood message-type for the given client-id")