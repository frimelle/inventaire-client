module.exports = (_)->
  idGenerator: (length, lettersOnly)->
    text = ''
    possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
    possible += '0123456789'  unless lettersOnly
    i = 0
    while i < length
      text += possible.charAt _.random(possible.length - 1)
      i++
    return text

  # adapted from http://werxltd.com/wp/2010/05/13/javascript-implementation-of-javas-string-hashcode-method/
  hashCode: (string)->
    [hash, i, len] = [0, 0, string.length]
    if len is 0 then return hash

    while i < len
      chr = string.charCodeAt(i)
      hash = ((hash << 5) - hash) + chr
      hash |= 0 # Convert to 32bit integer
      i++
    Math.abs hash

  niceDate: ->
    new Date().toISOString().split('T')[0]

  timeSinceMidnight: ->
    today = @niceDate()
    midnight = new Date(today).getTime()
    return _.now() - midnight

  buildPath: (pathname, queryObj, escape)->
    queryObj = @removeUndefined(queryObj)
    if queryObj? and not _.isEmpty queryObj
      queryString = ''
      for k,v of queryObj
        v = @dropSpecialCharacters(v)  if escape
        queryString += "&#{k}=#{v}"
      return pathname + '?' + queryString[1..-1]
    else pathname

  parseQuery: (queryString)->
    query = {}
    if queryString?
      queryString
      .replace /^\?/, ''
      .split '&'
      .forEach (param)->
        pairs = param.split '='
        if pairs[0]?.length > 0 and pairs[1]?
          query[pairs[0]] = _.softDecodeURI pairs[1]
    return query

  softEncodeURI: (str)->
    _.typeString str
    .replace /(\s|')/g, '_'
    .replace /\?/g, ''

  softDecodeURI: (str)->
    _.typeString str
    .replace /_/g,' '

  removeUndefined: (obj)->
    newObj = {}
    for k,v of obj
      if v? then newObj[k] = v
      else console.warn "#{k}:#{v} omitted"
    return newObj

  dropSpecialCharacters : (str)->
    str
    .replace /\s+/g, ' '
    .replace /(\?|\:)/g, ''

  isUrl: (str)->
    # adapted from http://stackoverflow.com/a/14582229/3324977
    pattern = '^(https?:\\/\\/)?'+ # protocol
      '(\\w+:\\w+@)?'+ # auth
      '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'+ # domain name
      '((\\d{1,3}\\.){3}\\d{1,3}))|'+ # OR ip (v4) address
      '(localhost)'+ # OR localhost
      '(\\:\\d+)?' + # port
      '(\\/[-a-z\\d%_.~+]*)*'+ # path
      '(\\?[;&a-z\\d%_.~+=-]*)?'+ # query string
      '(\\#[-a-z\\d_]*)?$'

    regexp = new RegExp pattern , "i"
    return regexp.test(str)

  isDataUrl: (str)-> /^data:image/.test str

  isHostedPicture: (str)-> /img(loc)?.inventaire.io\/\w{22}.jpg$/.test str

  pickToArray: (obj, props...)->
    if _.isArray(props[0]) then props = props[0]
    _.typeArray props
    pickObj = _.pick(obj, props)
    # returns an undefined array element when prop is undefined
    return props.map (prop)-> pickObj[prop]

  mergeArrays: _.union

  haveAMatch: (arrays...)-> _.intersection.apply(_, arrays).length > 0

  duplicatesArray: (str, num)-> [1..num].map -> str

  objLength: (obj)-> Object.keys(obj)?.length

  qrcode: (url, size=250)->
    "http://chart.apis.google.com/chart?cht=qr&chs=#{size}x#{size}&chl=#{url}"

  piped: (data)-> _.forceArray(data).join '|'

  expired: (timestamp, ttl)-> @now() - timestamp > ttl
