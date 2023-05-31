#
# APPEND to CSV
# --------------------------------

$('form[data-type][data-file$=".csv"]').on 'submit', ->
  form = $ @
  form.find(':input').blur()
  file_url = url_from_data_file form
  type = form.attr 'data-type'
  serialized = form.serializeArray()
  header = serialized.map((i) -> i.name).join ','
  row = serialized.map((i) -> i.value).join ','
  file = [header, row].join '\n'
  switch type
    when 'append'
      get_csv_file form, file_url, file, header, row
    else
      console.log type
  return # End form submit

$('form').on 'reset', ->
  form = $ @
  form.find(':input').blur()
  if document.hasFocus() then do focus
  return # End form reset