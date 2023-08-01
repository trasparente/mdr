#
# APPEND to CSV
# --------------------------------

$('form[data-file$=".csv"]').on 'submit', ->
  form = $ @
  form.find(':input').blur()
  file_url = url_from_data_file form
  serialized = form.serializeArray()
  header = serialized.map((i) -> i.name).join ','
  row = serialized.map((i) -> i.value).join ','
  file = [header, row].join '\n'
  get_csv_file form, file_url, file, header, row
  return # End form submit

$('form[data-file$=".json"]').on 'submit', ->
  form = $ @
  form.find(':input').blur()
  file_url = url_from_data_file form
  file = {}
  form.find(':input').each ->
    el = $ @
    name = el.attr 'name'
    type = el.attr 'type'
    tag = el.prop 'tagName'
    val = el.val()
    file[name] = if type in ['number', 'boolean'] then Number val else val
    return
  get_json_file form, file_url, JSON.stringify file
  return # End form submit

#
# Form RESET
# --------------------------------

$('form').on 'reset', ->
  form = $ @
  form.find(':input').blur()
  # Update focus class
  if document.hasFocus() then do focus
  return # End form reset