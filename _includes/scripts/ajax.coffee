#
# AJAX PREFILTER
# --------------------------------------
$.ajaxPrefilter (options, ajaxOptions, request) ->
  options.cache = false
  # Check GitHub requests
  if options.url.startsWith '{{ site.github.api_url }}'
    # Proper Accept header
    request.setRequestHeader 'Accept', 'application/vnd.github.v3+json'
    # Add GitHub token
    if localStorage.getItem 'token'
      request.setRequestHeader 'Authorization', "token #{localStorage.getItem 'token'}"
  return # End Ajax prefilter

# Control html.ajax class
$(document).ajaxStart () -> html.addClass 'ajax'
$(document).ajaxComplete () -> html.removeClass 'ajax'