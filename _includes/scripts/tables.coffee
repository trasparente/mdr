# TABLES
# --------------------------------------

# Assign type class (number, boolean, percent)
table_numbers = -> $('td').each ->
  cell = $ @
  string = +cell.text().trim()
  switch cell.data 'header'
    when '%' then cell.addClass 'percent'
    # Add 'number' class to number cells
    else
      if string and !isNaN string then cell.addClass 'number'
  return # End cells loop

# Durations
# Replace original date in repeating events
table_durations = -> $('tr').has('td[data-header="duration"]:not(:empty)').each ->
  row = $ @
  # Loop not empty duration cells
  row.find('td[data-header="duration"]:not(:empty)').each ->
    duration = duration_ms $(@).text().trim()
    # Get row date
    date_cell = row.find('td[data-header="date"]').eq(0)
    date_string = date_cell.text().trim()
    running = +new Date date_string
    if running < today
      while running < today
        running += duration
      # Update cell
      future_date = date_iso running
      time_el = date_cell.find('time').eq(0)
      time_el.text future_date + ' '
      time_el.attr
        title: "Original date #{date_string}"
        datetime: future_date
      time_el.data 'sort', future_date
    return # End 'duration' cells loop
  return # End table rows loop

# Sort by first column numeric values with [data-sort='asc/desc']
table_sort = -> $('table:not([data-sort=""]').each ->
  table = $ @
  # Sort function by `td time[data-sort]`
  rows = table.find('tbody tr').sort (a, b) ->
    value_a = $(a).find("td time").data('sort') || $(a).find("td time").attr 'datetime'
    value_b = $(b).find("td time").data('sort') || $(b).find("td time").attr 'datetime'
    if 'asc' is table.data 'sort'
      return if value_a <= value_b then -1 else 1
    if 'desc' is table.data 'sort'
      return if value_a >= value_b then -1 else 1
    return # End sort loop
  # Remove rows and append new sequence
  table.find('tbody tr').remove()
  table.find('tbody').append rows
  return # End table_sort

# Hide extra rows if data-limit attribute is set
# Negative limit show table bottom rows
table_limit = -> $('table[data-limit]').each ->
  table = $ @
  if table.data 'limit'
    limit = +table.data 'limit'
    rows = table.find('tbody tr')
    rows.each (i, e) ->
      if (limit > 0 and i > limit) or (limit < 0 and i < rows.length+limit - 1)
        $(e).hide()
      return # End data-limit loop
  return # End table_limit