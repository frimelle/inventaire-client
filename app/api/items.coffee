base = '/api/items'
publicBase = '/api/items/public'

module.exports =
  items: '/api/items'
  item: (owner, id, rev)->
    if owner? and id?
      if rev? then "/api/#{owner}/items/#{id}/#{rev}"
      else "/api/#{owner}/items/#{id}"
    else throw new Error "item API needs an owner, an id, and possibly a rev"

  lastPublicItems: itemsPublic 'last-public-items'

  publicByEntity: (uri)->
    itemsPublic 'public-by-entity',
      uri: uri

  publicByUsernameAndEntity: (uri)->
    itemsPublic 'public-by-username-and-entity',
      username: username
      uri: uri

  userPublicItems: (userId)->
    itemsPublic 'user-public-items',
      user: userId

itemsPublic = (action, query={})->
  _.buildPath publicBase, _.extend(query, { action: action })