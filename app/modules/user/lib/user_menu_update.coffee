AccountMenu = require 'modules/general/views/menu/account_menu'
NotLoggedMenu = require 'modules/general/views/menu/not_logged_menu'

module.exports = ->
  app.commands.setHandlers
    'show:user:menu:update': showMenu

  app.user.on 'change', (user)-> app.execute 'show:user:menu:update'

showMenu = ->
  if app.user.has 'email'
    view = new AccountMenu {model: app.user}
    app.layout?.accountMenu.show view
  else app.layout?.accountMenu.show new NotLoggedMenu

