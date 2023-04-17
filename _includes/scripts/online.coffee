#
# ONLINE / OFFLINE
# Called from BODY attribute
# --------------------------------------
@online = ->
  html.addClass('online').removeClass 'offline'
  check_update().then -> check_login()
  return
@offline = -> html.addClass('offline').removeClass 'online'
# Initial call
if navigator.onLine then online() else offline()