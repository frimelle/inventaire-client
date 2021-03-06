NotLoggedMenu = require 'modules/general/views/menu/not_logged_menu'

module.exports = Welcome = Backbone.Marionette.LayoutView.extend
  id: 'welcome'
  template: require './templates/welcome'
  regions:
    previewColumns: '#previewColumns'

  initialize: ->
    # importing loggin buttons events
    @events = NotLoggedMenu::events

  serializeData: ->
    loggedIn: app.user.loggedIn

  ui:
    topBarTrigger: '#middle-three'

  onShow: ->
    @loadPublicItems()
    unless app.user.loggedIn
      @hideTopBar()
      @ui.topBarTrigger.once 'inview', @showTopBar
      @hideFeedbacksButton()


  onDestroy: ->
    @showTopBar()
    @showFeedbacksButton()

  loadPublicItems: ->
    _.preq.get app.API.items.lastPublicItems
    .catch _.preq.catch404
    .then @displayPublicItems.bind(@)
    .catch @hidePublicItems.bind(@)
    .catch (err)-> _.error err, 'hidePublicItems err'

  displayPublicItems: (res)->
    unless res?.items?.length > 0 then return @hidePublicItems()

    app.users.public.add res.users

    items = new app.Collection.Items
    items.add res.items

    itemsColumns = new app.View.Items.List
      collection: items
      columns: true
    @previewColumns.show itemsColumns

  hidePublicItems: (err)->
    $('#lastPublicBooks').hide()
    if err? then throw err

  hideTopBar: -> $('.top-bar').hide()
  showTopBar: -> $('.top-bar').slideDown()

  hideFeedbacksButton: -> $('#feedbacks').hide()
  showFeedbacksButton: -> $('#feedbacks').fadeIn()