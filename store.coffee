# store.js
# a simple wrapper around html5 local storage and cookies
# provides three methods to interact with data
#
# it automatically purges data from localStorage if it's full.
#
# set: key, value
#    stores the value in a key
#    returns the value
# get: key
#    retrieves the value in the key
#    returns the value
# expire: key
#    removes the data and the key
#    returns the value

Store = do ->
  localStorageSupported = do ->
    try
      `(('localStorage' in window) && window['localStorage'] !== null)`
    catch e
      false

  if localStorageSupported
    # will displace data until it can successfully save
    safeSet = (key, value) ->
      try
        localStorage.setItem key, value
        value
      catch e
        for num in [0..5]
          localStorage.removeItem localStorage.key localStorage.length - 1
        safeSet key, value
    {
      set: safeSet

      get: (key) ->
        localStorage[key]

      expire: (key) ->
        value = localStorage[key]
        localStorage.removeItem(key)
        value
    }
  else
    createCookie = (name, value, days) ->
      if days
        date = new Date
        date.setTime(date.getTime() + (days*24*60*60*1000))
        expires = "; expires=" + date.toGMTString()
      else
        expires = ""

      document.cookie = name + "=" + value + expires + "; path=/"

      value

    getCookie = (key) ->
      key = key + "="
      for cookieFragment in document.cookie.split(';')
        return cookieFragment.replace(/^\s+/, '').substring(key.length, cookieFragment.length) if cookieFragment.indexOf(key) == 0
      return null

    {
      set: (key, value) ->
        createCookie key, value, 1

      get: getCookie

      expire: (key) ->
        value = Store.get key
        createCookie key, "", -1
        value
    }

