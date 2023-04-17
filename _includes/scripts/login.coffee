logout = (token) ->
  html.addClass('unlogged').removeClass ['logged', 'admin', 'guest']
  localStorage.removeItem 'token'
  localStorage.removeItem 'user'
  localStorage.removeItem 'role'
  localStorage.removeItem 'branch'
  localStorage.removeItem 'parent'
  if token then alert 'Logged out'
  return

check_login = (token) ->
  t = token || localStorage.getItem 'token'
  if t
    get_user = $.get
      url: '{{ site.github.api_url }}/user'
      headers: { 'Authorization': "token #{t}" }
    get_user.done (data) ->
      html.removeClass('unlogged').addClass 'logged'
      localStorage.setItem 'token', t
      localStorage.setItem 'user', user = data.login
      # Get permissions
      get_repo = $.get
        url: github_repo_url
        headers: { 'Authorization': "token #{t}" }
      get_repo.done (repo) ->
        localStorage.setItem 'branch', repo.default_branch
        localStorage.setItem 'parent', repo.parent?.full_name || ''
        # Store role
        role = if repo.permissions.admin then 'admin' else 'guest'
        html.addClass role
        localStorage.setItem 'role', role
        # check parent commit if it is a Fork
        if repo.parent?.full_name and role is 'admin' and html.attr 'data-github-fork', 'true'
          do check_parent
        # Alert for login
        if token then alert "#{user} logged as #{role}"
        return # End permission get_repo
      return # End get_user.done
    get_user.fail -> logout token
  else do logout
  return # End check_login

$('a[href="#login"]').on 'click', ->
  token = prompt "Paste a GitHub personal token"
  if token
    localStorage.removeItem 'token'
    check_login token
  return

$('a[href="#logout"]').on 'click', -> logout true