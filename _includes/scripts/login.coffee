logout = (token) ->
  html.addClass('unlogged').removeClass ['logged', 'admin', 'guest']
  localStorage.removeItem 'token'
  localStorage.removeItem 'user'
  localStorage.removeItem 'role'
  localStorage.removeItem 'branch'
  localStorage.removeItem 'parent'
  if token then alert 'Logged out'
  return

$('a[href="#login"]').on 'click', ->
  token = prompt "Paste a GitHub personal token"
  if token
    localStorage.removeItem 'token'
    bootstrap token
  return

$('a[href="#logout"]').on 'click', -> logout true