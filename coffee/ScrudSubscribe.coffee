SubscriptionSuccess = require("./ScrudSubscriptionSuccess")
Created = require("./ScrudCreated")

module.exports =  class ScrudSubscribe

  constructor: (@resourceType, @onSuccessFunction) ->

  send: (onSuccess, onCreated) =>

    @onSuccess = onSuccess
    @onCreated = onCreated

    message = {"message-type":"subscribe","client-id": @clientId, "resource-type": @resourceType, "resource": @resource}

    @Scrud.send(message)

  'subscription-success': (message) ->

    @onSuccess.call(this, new SubscriptionSuccess(message["resources"]))

  'created': (message) ->

    @onCreated.call(this, new Created(message['resource-id'], message.resource))