---
---
{% include scripts/helpers.coffee %}
{% include scripts/ajax.coffee %}
{% include scripts/update.coffee %}
{% include scripts/login.coffee %}
{% include scripts/online.coffee %}
{% include scripts/time.coffee %}
{% include scripts/tables.coffee %}
{% include scripts/form.coffee %}
#$('#prova').DataTable()

# Start table chain
$
  .when do table_numbers
  .then do table_durations
  .then do table_sort
  .then do time_relative