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

$('a[data-yaml]').each ->
  el = $ @
  console.log el.data 'yaml'
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
# Add `html.scrolled` when scroll > win height
# --------------------------------------
win.scroll () -> if win.scrollTop() > win.height() then html.addClass 'scrolled' else html.removeClass 'scrolled'

#
# FOCUS / BLUR
# Called from BODY attribute
# --------------------------------------
@focus = -> html.addClass('focus').removeClass 'blur'
@blur = -> html.addClass('blur').removeClass 'focus'
if document.hasFocus() then do focus else do blur

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
url_from_data_file = (form) ->
  path = form.attr 'data-file'
  # Prepend user folder if repository is forked
  if localStorage.getItem('parent') and body.attr('data-github-fork') is 'true'
    path = "user/#{ form.attr 'data-file' }"
  return "#{ github_repo_url }/contents/_data/#{ path }" # End url_from_data_file

# GitHub auth, personal token as argument
get_auth = (token) -> $.get
  url: '{{ site.github.api_url }}/user'
  headers: { 'Authorization': "token #{ token }" }
  success: (user) ->
    html.removeClass('unlogged').addClass 'logged'
    localStorage.setItem 'token', token
    localStorage.setItem 'user', user.login
    return # End get_auth done
  error: -> logout token

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
    if builds[0].status is 'built' or environment is 'development'
      if html.hasClass 'behind'
        history.pushState null, '', "#{ window.location }?update_to=#{ builds[0].updated_at }"
      html.removeClass('behind').addClass 'updated'
    else
      html.removeClass('updated').addClass 'behind'
      setTimeout get_builds, 1000*60
    return # End get_builds done

# Get parent repo last commit
get_parent_commits = (builds, repo) -> $.get
  url: "{{ site.github.api_url }}/repos/#{ repo.parent?.full_name }/commits"
  success: (commits) ->
    # Compare Jekyll build revision with parent last commit sha
    same_sha = commits[0].sha is '{{ site.github.build_revision }}'
    # Compare parent last commit time with this forked site last build time
    commit_after_build = +new Date(commits[0].commit.author.date) / 1000 > {{ site.time | date: "%s" }}
    console.log "same_sha, commit_after_build:", same_sha, commit_after_build
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
  error: (request, textStatus , errorThrown) -> save_if_404 request, form, file_url, file
  success: (data) ->
    # Decode old file
    csv_array = Base64.decode data.content
      .split '\n'
      .filter Boolean
    # Update old head
    csv_array[0] = header
    # append row
    csv_array.push row
    new_file = csv_array.join '\n'
    save_file form, file_url, new_file, data.sha
    return # End get_csv_file done

get_json_file = (form, file_url, file) -> $.get
  url: file_url
  # arguments: Object, 'error', 'Not Found'
  error: (request, textStatus , errorThrown) -> save_if_404 request, form, file_url, file
  success: (data) ->
    save_file form, file_url, file, data.sha
    return # End get_json_file done

# Save if file not found
save_if_404 = (request, form, file_url, file) ->
  if request.status is 404 then save_file form, file_url, file
  return # End save_if_404

save_file = (form, file_url, file, sha) -> $.ajax
  url: file_url
  method: 'PUT'
  data: if sha then JSON.stringify {
    message: "Commit data content #{ form.attr 'data-file' }"
    sha: sha
    content: Base64.encode file
  } else JSON.stringify {
    message: "Commit data content #{ form.attr 'data-file' }"
    content: Base64.encode file
  }
  success: (data) ->
    alert "Committed #{ data.content.path } as #{ data.commit.sha.slice 0, 7 }"
    form.trigger 'reset'
    html.removeClass('updated').addClass 'behind'
    if environment isnt 'development' then do get_builds
    return # End save_file

# Bootstrap
bootstrap = (token) ->
  t = token || localStorage.getItem 'token'
  if t
    get_auth(t).done (user) ->
      get_repo(user, token).done (repo) ->
        if repo.permissions.admin then get_builds().done (builds) ->
          if repo.fork and builds[0].status is 'built' then get_parent_commits builds, repo
  else do logout
  return # End bootstrap

#
# ONLINE / OFFLINE
# Called from BODY attribute
# --------------------------------------
@online = ->
  html.addClass('online').removeClass 'offline'
  do bootstrap
  return # End online
@offline = -> html.addClass('offline').removeClass 'online'
# Initial call
if navigator.onLine then do online else do offline