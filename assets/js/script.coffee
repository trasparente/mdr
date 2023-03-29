---
---
{% include scripts/time.coffee %}
{% include scripts/helpers.coffee %}
{% include scripts/tables.coffee %}
{% include scripts/sync.coffee %}
#$('#prova').DataTable()

# Start table chain
$
  .when do sync
  .then do table_numbers
  .then do table_durations
  .then do table_sort
  .then do time_relative