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
if document.hasFocus() then focus() else blur()

# Return ISO 8601 date YYYY-MM-DD
date_iso = (date) -> new Date(date || +new Date()).toLocaleDateString 'sv'

# Get file url from data-file FORMs attribute
url_from_data_file = (form) ->
  path = form.attr 'data-file'
  # Prepend user folder if repository is forked
  if localStorage.getItem('parent') and html.attr 'data-github-fork', 'true'
    url = "user/{{ site.github.owner_name }}/#{ path }"
  return "#{ github_repo_url }/contents/_data/#{url || path}"