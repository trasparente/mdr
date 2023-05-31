#
# VAR
# --------------------------------------
win = $(window)
dom = $(document)
html = $ 'html'
body = $ 'body'
today = +new Date().setHours 0,0,0,0
github_repo_url = '{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}'
lang = '{{ page.language | default: site.language | default: "it" }}'
if $('meta[name="remote_theme"]').attr 'content' then html.addClass 'remote-theme'

#
# PREVENT-DEFAULT CLASS
# --------------------------------------
dom.on 'click', 'a.prevent', (e) -> e.preventDefault()
dom.on 'submit', 'form.prevent', (e) -> e.preventDefault()

#
# SCROLL Event
# Add `html.scrolled` when scroll > win height
# --------------------------------------
win.scroll () ->
  if win.scrollTop() > win.height()
    html.addClass 'scrolled'
  else html.removeClass 'scrolled'
  return

#
# FOCUS / BLUR
# Called from BODY attribute
# --------------------------------------
@focus = -> html.addClass('focus').removeClass 'blur'
@blur = -> html.addClass('blur').removeClass 'focus'
if document.hasFocus() then do focus else do blur

# Return ISO 8601 date YYYY-MM-DD
date_iso = (date) -> new Date(date || +new Date()).toLocaleDateString 'sv'

# Get file url from data-file FORMs attribute
url_from_data_file = (form) ->
  path = form.attr 'data-file'
  # Prepend user folder if repository is forked
  if localStorage.getItem('parent') and body.attr('data-github-fork') is 'true'
    url = "user/{{ site.github.owner_name }}/#{ path }"
  return "#{ github_repo_url }/contents/_data/#{url || path}"

get_user = (t) -> $.get
  url: '{{ site.github.api_url }}/user'
  headers: { 'Authorization': "token #{t}" }
  success: (user) ->
    html.removeClass('unlogged').addClass 'logged'
    localStorage.setItem 'token', t
    localStorage.setItem 'user', user.login
    return
  error: -> logout t

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
    return

# Get repository builds and check the last one
get_builds = -> $.get
  url: github_repo_url + '/pages/builds'
  success: (builds) ->
    # Compare last repository build with hardcoded jekyll deployment
    same_sha = builds[0].commit is '{{ site.github.build_revision }}' 
    deploy_post_build = {{ site.time | date: "%s" }} > +new Date(builds[0].created_at) / 1000
    built = builds[0].status is 'built'
    development = '{{ site.github.environment }}' is 'development'
    if (built and same_sha and deploy_post_build) or development
      html.removeClass('behind').addClass 'updated'
    else html.removeClass('updated').addClass 'behind'
    return

get_parent_commits = (builds, repo) -> $.get
  url: "{{ site.github.api_url }}/repos/#{ repo.parent?.full_name }/commits"
  success: (commits) ->
    same_sha = commits[0].sha is '{{ site.github.build_revision }}'
    build_after_commit = +new Date(commits[0].commit.author.date) / 1000 < {{ site.time | date: "%s" }}
    switch [same_sha, build_after_commit]
      when [false, false]
        sync_upstream().done -> do get_builds
      when [false, true]
        console.log 'could PR'
      else console.log same_sha, build_after_commit
    return # End check_parent success

# Sync with upstream
# https://docs.github.com/en/rest/branches/branches#sync-a-fork-branch-with-the-upstream-repository
sync_upstream = -> $.ajax
  url: github_repo_url + '/merge-upstream'
  method: 'POST'
  data: JSON.stringify {"branch": localStorage.getItem 'branch' }
  success: (response) -> alert response.message

get_csv_file = (form, file_url, file, header, row) -> $.get
  url: file_url
  # arguments: Object, 'error', 'Not Found'
  error: (request, textStatus , errorThrown) ->
    # File don't exist
    if request.status is 404
      save_file form, file_url, file
    return # End get_csv_file fail
  success: (data) ->
    # Decode old file
    csv_array = Base64.decode(data.content).split '\n'
    # Update old head
    csv_array[0] = header
    # append row
    csv_array.push row
    new_file = csv_array.join '\n'
    save_file form, file_url, new_file
    return # End get_csv_file done

save_file = (form, file_url, file) -> $.ajax
  url: file_url
  method: 'PUT'
  data: JSON.stringify {
    message: "Commit data content #{ form.attr 'data-file' }"
    content: Base64.encode file
  }
  success: (data) ->
    form.trigger 'reset'
    html.removeClass('updated').addClass 'behind'
    alert "Committed #{ data.content.sha }"
    return # End put_file

# Bootstrap
bootstrap = (token) ->
  t = token || localStorage.getItem 'token'
  if t
    get_user(t).done (user) -> get_repo(user, token).done (repo) -> if repo.permissions.admin then get_builds().done (builds) -> if repo.fork then get_parent_commits builds, repo
  else do logout
  return

#
# ONLINE / OFFLINE
# Called from BODY attribute
# --------------------------------------
@online = ->
  html.addClass('online').removeClass 'offline'
  do bootstrap
  return
@offline = -> html.addClass('offline').removeClass 'online'
# Initial call
if navigator.onLine then do online else do offline