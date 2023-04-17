#
# APPEND to CSV
# --------------------------------

$('form[data-type][data-file$=".csv"]').on 'submit', ->
  form = $ @
  form.find(':input').blur()
  file_name = form.attr 'data-file'
  type = form.attr 'data-type'
  serialized = form.serializeArray()
  header = serialized.map((i) -> i.name).join ','
  row = serialized.map((i)-> i.value).join ','
  file = [header, row].join '\n'
  switch type
    when 'append'
      file_url = url_from_data_file form
      check_file form, file_url, file, header, row
    else
      console.log type
  return # End form submit

$('form').on 'reset', ->
  form = $ @
  form.find(':input').blur()
  return # End form reset

@check_file = (form, file_url, file, header, row) ->
  get_file = $.get file_url
  # arguments: Object, 'error', 'Not Found'
  get_file.fail (request, textStatus , errorThrown) ->
    # File don't exist
    if request.status is 404
      save_file form, file_url, file
    return # End get_file fail
  get_file.done (data) ->
    # Decode old file
    csv_array = Base64.decode(data.content).split '\n'
    # Update old head
    csv_array[0] = header
    # append row
    csv_array.push row
    new_file = csv_array.join '\n'
    save_file form, file_url, new_file
    return # End get_file done
  return # End save_file

@save_file = (form, file_url, file) ->
  # Prepare commit
  load =
    message: "Commit data content #{ form.attr 'data-file' }"
    content: Base64.encode file
  # Commit new file
  put_file = $.ajax file_url,
    method: 'PUT'
    data: JSON.stringify load
  put_file.done (data) ->
    alert "Committed #{ data.content.sha }"
    form.trigger 'reset'
    return # End put_file
  return # End save file