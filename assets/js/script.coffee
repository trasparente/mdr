---
---
{% include scripts/time.coffee %}
{% include scripts/helpers.coffee %}
{% include scripts/tables.coffee %}
#$('#prova').DataTable()

# Start table chain
$
  .when do table_numbers
  .then do table_durations
  .then do table_sort
  .then do time_relative