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

# TABLES HELPERS
# --------------------------------------

# Loop cells
$('td').each ->
  cell = $ @
  value = cell.text().trim()
  # Number values class
  string = +value
  if string and !isNaN string then cell.addClass 'number'
  # check Duration
  if cell.data('header') is 'duration' and value.startsWith 'P'
    duration = duration_ms value
    # Loop from event to today
    # running = +new Date(row_values[date_index_array[0]])
    # today = +new Date().setHours 0,0,0,0
    # if running < today
    #   while running < today
    #     running += duration
    #   # Create and store ghost event
    #   # Array shallow copy
    #   new_values = row_values.slice 0
    #   origin_date.push row_values[date_index_array[0]]
    #   new_values[date_index_array[0]] = date_iso running
    #   ghost.push new_values.join ','
  return