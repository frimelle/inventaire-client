behavior = (name)-> require "modules/general/views/behaviors/templates/#{name}"
check = behavior 'success_check'
input = behavior 'input'
SafeString = Handlebars.SafeString


# data =
#   nameBase: {String}
#   id: {String} *
#   special: {Boolean}
#   field:
#     id: {String} *
#     name: {String} *
#     value: {String}
#     type: {String}
#     placeholder: {String} *
#     dotdotdot: {String}
#     classes: {String}
#   button:
#     id: {String} *
#     text: {String} *
#     icon: {String} (replaces button.text)
#     classes: {String}
#
# (*) guess from nameBase


module.exports =
  input: (data, options)->
    unless data?
      _.log arguments, 'input arguments @err'
      throw new Error 'no data'

    # default data, overridden by arguments
    field =
      type: 'text'
      dotdotdot: '...'
    button =
      classes: 'success postfix'

    name = data.nameBase
    if name?
      field.id = name + 'Field'
      field.name = name
      field.placeholder = _.i18n(name)
      button.id = name + 'Button'
      button.text = name

    if data.button?.icon?
      data.button.text = "<i class='fa fa-#{data.button.icon}'></i>"

    # data overriding happens here
    data =
      id: "#{name}Group"
      field: _.extend field, data.field
      button: _.extend button, data.button

    if data.special
      data.special = 'autocorrect="off" autocapitalize="off"'

    i = new SafeString input(data)

    if options is 'check' then new SafeString check(i)
    else i

  disableAuto: -> 'autocorrect="off" autocapitalize="off"'
