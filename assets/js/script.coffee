---
---
{% include scripts/helpers.coffee %}
{% include scripts/ajax.coffee %}
{% include scripts/login.coffee %}
{% include scripts/update.coffee %}
{% include scripts/time.coffee %}
{% include scripts/tables.coffee %}
#$('#prova').DataTable()

# Start table chain
$
  .when do table_numbers
  .then do table_durations
  .then do table_sort
  .then do time_relative
  .then do check_update