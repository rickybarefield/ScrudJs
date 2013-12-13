module.exports =  class ScrudCreate

  constructor: (@type, @resource, @onSuccessFunction) ->

  send: ->

    message = {'client-id': @clientId, type: @type, resource: @resource}

    @Scrud.send(message)

  handle: (message) =>

    switch message["message-type"]

      when 'create-success' then @onSuccessFunction.apply(this, message)

      else console.log("Warning a response was received but not of an understood message-type for the given client-id")