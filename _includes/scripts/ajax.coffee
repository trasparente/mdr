#
# AJAX PREFILTER
# --------------------------------------
$.ajaxPrefilter (options, ajaxOptions, request) ->
  # Check GitHub requests
  if options.url.startsWith '{{ site.github.api_url }}'
    # Proper Accept header
    request.setRequestHeader 'Accept', 'application/vnd.github.v3+json'
    options.cache = false
    # Add GitHub token
    if localStorage.getItem 'token'
      request.setRequestHeader 'Authorization', "token #{localStorage.getItem 'token'}"

  return # End Ajax prefilter

# Control html.ajax class
$(document).ajaxStart () -> html.addClass 'ajax'
$(document).ajaxComplete (event, request, ajaxOptions) -> html.removeClass 'ajax'