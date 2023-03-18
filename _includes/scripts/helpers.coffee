#
# VAR
# --------------------------------------
win = $(window)
dom = $(document)
html = $ 'html'
body = $ 'body'
root_path = new URL("{{ '' | absolute_url }}").pathname
lang = '{{ page.language | default: site.language | default: 'en' }}'

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