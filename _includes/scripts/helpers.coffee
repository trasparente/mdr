# YAML to JSON: jsyaml.load YAML-string
# JSON to YAML: jsyaml.dump JSON-object

#
# VAR
# --------------------------------------
win = $(window)
dom = $(document)
html = $ 'html'
body = $ 'body'
today = +new Date().setHours 0,0,0,0
environment = '{{ site.github.environment }}'
github_repo_url = '{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}'
lang = '{{ page.language | default: site.language | default: "it" }}'

# Data
data_user = {% if site.data.user %}{{ site.data.user | jsonify }}{% else %}{}{% endif %}
data_fork = {% if site.data.form %}{{ site.data.form | jsonify }}{% else %}{}{% endif %}

# Prevent-default class
dom.on 'click', 'a.prevent', (e) -> e.preventDefault()
dom.on 'submit', 'form.prevent', (e) -> e.preventDefault()

# Appearance
# --------------------------------------
# Citations
$('[cite]:not([title])').each -> $(@).attr 'title', $(@).attr('cite')
# Links
$('a:not([title])').each -> $(@).attr 'title', $(@).attr('href')
# Anchor links gets details opened
$("[href^='#']").on "click", ->
  targetDIV = $ @.getAttribute "href"
  if targetDIV.is ":hidden"
    targetDIV.closest("details").prop "open", true
  return

# Preview JSON file
# Attribute [data-json]
# --------------------------------------
$('[data-json]').each ->
  el = $ @
  text = JSON.stringify JSON.parse(el.text()), null, 2
    .replace /(\s)(\d)/g, '$1<span class="mi">$2</span>' # Number .mi
    .replace /(:\s)(\".+\")/g, '$1<span class="s2">$2</span>' # Value string .s2
    .replace /(\".+\")(:\s)/g, '<span class="nl">$1</span>$2' # Property string .nl
    .replace /[\[\]\{\}\:\,]/g, '<span class="p">$&</span>' # Punctuation .p
  el.html text
  return

# Preview YML file
# Attribute [data-yml]
# --------------------------------------
$('[data-yml]').each ->
  el = $ @
  text = jsyaml.dump JSON.parse(el.text()), null, 2
    .replace /(\s)(\d)/g, ' <span class="m">$2</span>' # Number .m
    .replace /(: )(.*)/g, '$1<span class="s">$2</span>' # Value string .s
    .replace /(.+)(:\s)/g, '<span class="na">$1</span>$2' # Property string .na
    .replace /[\:\-]/g, '<span class="pi">$&</span>' # Punctuation .pi
  el.html text
  return

#
# SCROLL Event
# Add `html.scrolled` when scroll > win height (1 page)
# --------------------------------------
win.scroll () -> if win.scrollTop() > win.height() then html.addClass 'scrolled' else html.removeClass 'scrolled'

#
# FOCUS / BLUR
# Called from BODY events
# --------------------------------------
@focus = -> html.addClass('focus').removeClass 'blur'
@blur = -> html.addClass('blur').removeClass 'focus'
if document.hasFocus() then do focus else do blur

# SOMA audio streaming detector
@soma = $ 'audio#soma'
soma_playing = false
soma.on 'playing', -> console.log $(@)
soma.on 'suspend', -> console.log 'suspend'

#
# FULLSCREEN: WINDOW RESIZE EVENT
# Add class `fullscreen`
# Called from BODY attribute
# --------------------------------------
@resize = ->
  if window.innerHeight is screen.height then html.addClass 'fullscreen'
  else html.removeClass 'fullscreen'
  return

resize()

# Return ISO 8601 date YYYY-MM-DD
date_iso = (date) -> new Date(date || +new Date()).toLocaleDateString 'sv'

# Get data file url from data-file form attribute
# If it is a fork, save inside 'user' folder
url_from_data_file = (form) -> "#{ github_repo_url }/contents/_data/#{ form.data 'file' }"

# GitHub auth, personal token as argument
get_auth = (token) -> $.get
  url: '{{ site.github.api_url }}/user'
  headers: { 'Authorization': "token #{ token }" }
  success: (user) ->
    html.removeClass('unlogged').addClass 'logged'
    localStorage.setItem 'token', token
    localStorage.setItem 'user', user.login
    return # End get_auth done
  error: (request) -> # Reset token if Requires authentication or Forbidden
    if [401, 403].includes request.status then logout token else do logout
    return # End get_auth error

get_repo = (user, token) -> $.get
  url: github_repo_url
  success: (repo) ->
    localStorage.setItem 'branch', repo.default_branch
    localStorage.setItem 'parent', repo.parent?.full_name || ''
    # Store role
    role = if repo.permissions.admin then 'admin' else 'guest'
    html.addClass role
    localStorage.setItem 'role', role
    # Alert for login
    message = "#{ user.login } logged as #{ role }"
    $('[href="#logout"]').attr 'title', message
    if token then alert message
    return # End get_repo done

# Get pages builds and check the last one
get_builds = -> $.get
  url: github_repo_url + '/pages/builds'
  success: (builds) ->
    spy = $ '#spy .behind'
    if builds[0].status is 'built' or environment is 'development'
      # -------
      # UPDATED
      # -------
      if html.hasClass 'behind'
        # Was behind
        updated_url = [
          window.location.origin
          window.location.pathname
          '?update_to='
          builds[0].updated_at
        ].join ''
        history.pushState null, '', updated_url
        # Activate button
        spy.addClass 'foreground-blink pointer'
        spy.on 'click', () -> window.location.href = updated_url
      else
        html.removeClass 'behind'
          .addClass 'updated'
    else
      # ------
      # BEHIND
      # ------
      html.removeClass 'updated'
        .addClass 'behind'
      # Check again in 60 thousands of milliseconds
      setTimeout get_builds, 1000*60

    return # End get_builds done

# Get parent repo last commit
get_parent_commits = (builds, repo) -> $.get
  url: "{{ site.github.api_url }}/repos/#{ repo.parent?.full_name }/commits"
  success: (commits) ->
    # Compare parent last commit time with this forked site last build time
    commit_after_build = +new Date(commits[0].commit.author.date) / 1000 > {{ site.time | date: "%s" }}
    if commit_after_build then sync_upstream().done -> do get_builds
    return # End get_parent_commits done

# Sync with upstream
# https://docs.github.com/en/rest/branches/branches#sync-a-fork-branch-with-the-upstream-repository
sync_upstream = -> $.ajax
  url: github_repo_url + '/merge-upstream'
  method: 'POST'
  data: JSON.stringify { "branch": localStorage.getItem 'branch' }
  success: (response) -> alert response.message

get_csv_file = (form, file_url, file, header, row) -> $.get
  url: file_url
  # arguments: Object, 'error', 'Not Found'
  error: (request, textStatus , errorThrown) -> if request.status is 404 then save_file form, file_url, file
  success: (data) ->
    # Decode old file and split
    # Boolean remove empty elements
    csv_array = Base64.decode data.content
      .split '\n'
      .filter Boolean
    # Update old head
    csv_array[0] = header
    # append row
    csv_array.push row
    new_file = csv_array.join '\n'
    save_file form, file_url, new_file, {sha: data.sha}
    return # End get_csv_file done

get_json_file = (form, file_url, file) -> $.get
  url: file_url
  # arguments: Object, 'error', 'Not Found'
  error: (request, textStatus , errorThrown) -> if request.status is 404 then save_file form, file_url, file
  success: (data) -> save_file form, file_url, file, {sha: data.sha}

save_file = (form, file_url, file, data) -> $.ajax
  url: file_url
  method: 'PUT'
  data: JSON.stringify $.extend {
    message: "Commit data content #{ form.data 'file' }"
    content: Base64.encode file
  }, data
  success: (data) ->
    alert "Committed #{ data.content.path } as #{ data.commit.sha.slice 0, 7 }"
    form.trigger 'reset'
    html.removeClass('updated').addClass 'behind'
    if environment isnt 'development' then do get_builds
    return # End save_file

# Get Forks recursively
get_forks = (pg = 1, forks = []) -> $.get
  url: github_repo_url + '/forks'
  per_page: 100
  page: pg
  success: (data, status, request) ->
    output = forks.concat data
    links = request.getResponseHeader 'links'
    if links && links.includes 'rel="next"'
      get_forks pg+1, output
    else console.log "#{fork.name} #{fork.updated_at} #{fork.id}" for fork in output 
    return # End get_forks

# Bootstrap
bootstrap = (token) ->
  t = token || localStorage.getItem 'token'
  if t
    get_auth(t).done (user) ->
      get_repo(user, token).done (repo) ->
        if repo.permissions.admin then get_builds().done (builds) ->
          if repo.fork and builds[0].status is 'built'
            get_parent_commits builds, repo
          else do get_forks
  else do logout
  return # End bootstrap

#
# ONLINE / OFFLINE
# Called from BODY attribute
# --------------------------------------
@online = ->
  html.addClass('online').removeClass 'offline'
  if soma_playing
    soma[0].load()
    soma[0].play()
  return
@offline = -> html.addClass('offline').removeClass 'online'
# Initial call
if navigator.onLine then do online else do offline