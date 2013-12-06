module.exports =  class ScrudCreate

  constructor: (@clientId, @type, @resource, @onSuccessFunction) ->

  send: ->

    message = {'client-id': @clientId, type: @type, resource: @resource}

    @Scrud.send(message)