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
  serialized = form.serializeArray()
  console.log serialized
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