var Store;
Store = (function() {
  var createCookie, getCookie;
  createCookie = function(name, value, days) {
    var date, expires;
    if (days) {
      date = new Date();
      date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
      expires = "; expires=" + date.toGMTString();
    } else {
      expires = "";
    }
    document.cookie = name + "=" + value + expires + "; path=/";
    return document.cookie;
  };
  getCookie = function(key) {
    var _a, _b, _c, cookieFragment;
    key = key + "=";
    _b = document.cookie.split(';');
    for (_a = 0, _c = _b.length; _a < _c; _a++) {
      cookieFragment = _b[_a];
      while (cookieFragment.charAt(0) === ' ') {
        cookieFragment.substring(1, cookieFragment.length);
      }
      if (cookieFragment.indexOf(key) === 0) {
        return cookieFragment.substring(key.length, cookieFragment.length);
      }
    }
    return null;
  };
  return (('localStorage' in window) && window['localStorage'] !== null) ? {
    set: function(key, value) {
      localStorage[key] = value;
      return localStorage[key];
    },
    get: function(key) {
      return localStorage[key];
    },
    expire: function(key) {
      return localStorage.removeItem(key);
    }
  } : {
    set: function(key, value) {
      return createCookie(key, value, 1);
    },
    get: getCookie,
    expire: function(key) {
      return createCookie(key, "", -1);
    }
  };
})();