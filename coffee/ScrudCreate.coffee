CreateSuccess = require("./ScrudCreateSuccess")

module.exports =  class ScrudCreate

  constructor: (@resourceType, @resource) ->

  send: (onSuccessFunction) =>

    @onSuccessFunction = onSuccessFunction

    message = {"message-type": "create", "client-id": @clientId, "resource-type": @resourceType, "resource": @resource}

    @Scrud.send(message)

  'create-success': (message) => @onSuccessFunction.call(this, new CreateSuccess(message["resource-id"], message["resource"]))
