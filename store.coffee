# store.js
# a simple wrapper around html5 local storage and cookies
# provides three methods to interact with data
#
# set: key, value
#    stores the value in a key
# get: key
#    retrieves the value in the key
# expire: key
#    removes the data and the key

Store: (->
  createCookie: (name, value, days) ->
    if days
      date: new Date
      date.setTime(date.getTime() + (days*24*60*60*1000))
      expires: "; expires=" + date.toGMTString()
    else
      expires: ""
    document.cookie: name + "=" + value + expires + "; path=/"

  getCookie: (key) ->
    key: key + "="
    for cookieFragment in document.cookie.split(';')
      while cookieFragment.charAt(0) is ' '
        cookieFragment: cookieFragment.substring(1, cookieFragment.length) 
      return cookieFragment.substring(key.length, cookieFragment.length) if cookieFragment.indexOf(key) == 0
    return null

  if `(('localStorage' in window) && window['localStorage'] !== null)`
    {
      set: (key, value) -> localStorage[key]: value
      get: (key) -> localStorage[key]
      expire: (key) -> localStorage.removeItem(key)
    }
  else
    {
      set: (key, value) -> createCookie(key, value, 1)
      get: getCookie
      expire: (key) -> createCookie(key, "", -1)
    }
)()
