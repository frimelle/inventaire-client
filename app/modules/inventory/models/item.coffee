Filterable = require 'modules/general/models/filterable'

module.exports = Item = Filterable.extend
  url: -> app.API.items.base

  validate: (attrs, options)->
    unless attrs.title? then return "a title must be provided"
    unless attrs.owner? then return "a owner must be provided"

  initialize: (attrs, options)->
    # RECIPE:
      # entity = entity "#{domain}:#{id} uri
      # pathname = "#{username}/#{entity}/#{title}
    # - allows entity uri to be used in pathname
    # nice for super users/wikidata wizzards
    # - using timestamp to avoid possible collissions
    # between one user's items

    unless attrs.entity?
      throw new Error "item should have an associated entity"

    attrs.entity = app.request 'normalize:entity:uri', attrs.entity
    # entity data are requested when needed:
    # getEntityModel is commented-out as this data isnt
    # needed at startup currently
    # (items title and pictures are from the item, not the entity)
    # @getEntityModel(attrs.entity)

    attrs.owner = @get('owner')
    # created will be overriden by the server at item creation
    attrs.created = @get('created') or _.now()
    attrs._id = @getId(attrs)

    @set attrs

    {entity, title, owner} = attrs
    @username = app.request 'get:username:from:userId', owner
    @profilePic = app.request 'get:profilePic:from:userId', owner
    @pathname = @buildPathname(attrs)
    @restricted = owner isnt app.user.id
    @entityPathname = app.request 'get:entity:local:href', entity, title

  getId: (attrs)->
    if @get('_id') then return @get('_id')
    else return 'new'

  buildPathname: (attrs)->
    if @username? and attrs.entity?
      pathname = "/inventory/#{@username}/#{attrs.entity}"
      title = _.softEncodeURI @get('title')
      pathname += "/#{title}"  if title?
      return pathname
    else return

  serializeData: ->
    attrs = @toJSON()
    _.extend attrs,
      username: @username
      pathname: @pathname
      entityPathname: @entityPathname
      profilePic: @profilePic
      restricted: @restricted
      created: moment(attrs.created).fromNow()

    attrs.currentTransaction = Items.transactions[attrs.transaction]
    unless attrs.restricted
      attrs.transactions = Items.transactions
      attrs.listings = app.user.listings
      attrs.uiId = _.uniqueId('item_')
      if attrs.listing?
        attrs.currentListing = app.user.listings[attrs.listing]
      else
        # main user item fetched from a public API
        # requires to borrow its listing to the private item
        listing = app.request('get:item:model', attrs._id)?.get('listing')
        attrs.currentListing = app.user.listings[listing]

    if @entity? then attrs.entity = @entity.toJSON?()

    # picture may be undefined
    attrs.picture = attrs.pictures?[0]

    return attrs

  asMatchable: ->
    [
      @get('title')
      @get('username')
      @get('comment')
      @get('notes')
      @get('entity')
    ]

  getEntityModel: (uri)->
    app.request 'get:entity:model', uri
    .then (entityModel)=> @entity = entityModel
    .catch (err)-> console.error 'get:entity:model catch', err

  # passing id and rev as query paramaters
  destroy: ->
    # reproduce the behavior from the default Bacbkone::destroy
    @trigger 'destroy', @, @collection
    url = _.buildPath @url(),
      id: @id
      rev: @get('_rev')
    return _.preq.delete url
