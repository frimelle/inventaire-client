module.exports = RequestLi = Backbone.Marionette.ItemView.extend
  tagName: "li"
  className: "requestLi"
  template: require './templates/request_li'
  events:
    'click #discard': -> app.request 'request:discard', @model
    'click #accept': -> app.request 'request:accept', @model