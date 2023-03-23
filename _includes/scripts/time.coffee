#
# Return milliseconds
# ms 'second/minute/hour/day/week/month/year'
# --------------------------------------
ms = (unit) ->
  return switch unit
    when 'second' then 1000
    when 'minute' then 1000 * 60
    when 'hour' then 1000 * 60 * 60
    when 'day' then 1000 * 60 * 60 * 24
    when 'week' then 1000 * 60 * 60 * 24 * 7
    when 'month' then 1000 * 60 * 60 * 24 * 30.42
    when 'year' then 1000 * 60 * 60 * 24 * 7 * 52.14
    else 0

time =
  # Time difference
  diff: (date) -> Date.now() - +new Date(Date.parse date)
  # Add 's' for plural units
  s: (value) -> if value > 1 then 's' else ''
  # Given a time difference and the gap string:
  # append ' ago' if past, or prepend 'in ' if future
  in_ago: (diff, string) -> if diff > 0 then "#{string} ago" else "in #{string}"
  # Given a [time-relative] element:
  # return attribute value or text content
  get_date: (e) -> $(e).attr('datetime') || Date.now()

  # Given a [time-classes] element:
  # Add relative class (past, future, today, tomorrow)
  classes: (e) ->
    el = $ e
    arr = []
    d = time.get_date e
    if !Date.parse d then return
    date = new Date d
    el.removeClass 'past future today tomorrow'
    if date.setHours(0,0,0,0) is new Date().setHours(0,0,0,0)
      arr.push 'today'
    if date.setHours(0,0,0,0) is new Date().setHours(0,0,0,0) + ms 'day'
      arr.push 'tomorrow'
    if time.diff(date) > 0 then arr.push 'past' else arr.push 'future'
    el.addClass arr.join ' '
    return

  # Given a [time-relative] element:
  # return a human string
  string: (e) ->
    d = time.get_date e
    if !Date.parse d then return
    diff = time.diff d
    abs = Math.abs diff
    unit = switch
      when abs < ms('minute') then 'second'
      when abs < ms('minute')*59 then 'minute'
      when abs < ms('day') then 'hour'
      when abs < ms('week')*2 then 'day'
      when abs < ms('week')*3.5 then 'week'
      when abs < ms('month')*11 then 'month'
      # abs < ms('year')
      else 'year'
    number = Math.round abs / ms unit
    timeout = switch
      when unit is 'second' then ms 'second'
      when unit in ['day','hour','minute'] then ms 'minute'
      else ms 'day'
    setTimeout time.relative, timeout, e
    string = time.in_ago diff, "#{number} #{unit}#{time.s number}"
    if string in ['0 second ago', 'in 0 second'] then string = 'now'
    return string

  # Given a [time-relative] element:
  # append a span element with human string
  # replace title with reference date
  relative: (e) ->
    string = time.string e
    date = new Date(time.get_date e)
    $(e).attr 'title', date.toLocaleDateString(lang, {
        day: "numeric"
        month: "short"
        year: "numeric"
      }) + ' ' + date.toLocaleTimeString(lang)
    if $(e).find('span').length
      $(e).children('span').text string
    else
      $(e).append $ '<span/>', {text: string}
    time.classes e
    return

# Convert ISO-8601 duration string in milliseconds
duration_ms = (string) ->
  duration = 0
  array = string.match(/^P(\d+Y)?(\d+M)?(\d+W)?(\d+D)?(T(\d+H)?(\d+M)?(\d+S)?)?$/) || []
  ms_array = [null, ms('year'), ms('month'), ms('week'), ms('day'), null, ms('hour'), ms('minute'), ms('second')]
  # Loop milliseconds array
  for e, i in ms_array
    # If milliseconds and string match,
    if e and array[i] then duration += e * +array[i].slice 0, -1
  return duration

#
# Append `span` with in/ago text
# inside `time[datetime]`
# --------------------------------------
$('time[datetime]').each -> time.relative @