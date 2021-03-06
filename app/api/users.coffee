module.exports =
  data: (ids)->
    ids = _.forceArray(ids)
    if _.all ids, _.isUserId
      ids = ids.join '|'
      return "/api/users?action=getusers&ids=#{ids}"
    else throw new Error "users data API needs an array of valid user ids"
  items: (ids)->
    ids = _.forceArray(ids)
    if ids?
      ids = ids.join '|'
      return "/api/users?action=getitems&ids=#{ids}"
    else throw new Error "users' items API needs an id"
  search: (text)->
    if text? then "/api/users?action=search&search=#{text}"
    else throw new Error "users' search API needs a text argument"