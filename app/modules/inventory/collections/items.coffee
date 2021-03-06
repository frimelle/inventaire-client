module.exports = Items = Backbone.Collection.extend
  model: require "../models/item"
  url: -> app.API.items.base

  comparator: (item)-> - item.get 'created'

  byOwner: (ownerId)-> @where {owner: ownerId}

  byEntityUri: (uri)-> @where {entity: uri}

  byUsername: (username)->
    owner = app.request 'get:userId:from:username', username
    return @where {owner: owner}