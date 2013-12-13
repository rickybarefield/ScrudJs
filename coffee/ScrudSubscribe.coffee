module.exports =  class ScrudSubscribe

  constructor: (@resourceType, @onSuccessFunction) ->

  send: ->

    message = {"client-id": @clientId, "resource-type": @resourceType, "resource": @resource}

    @Scrud.send(message)
