---
---
{% include scripts/ajax.coffee %}
{% include scripts/login.coffee %}
{% include scripts/helpers.coffee %}
{% include scripts/time.coffee %}
{% include scripts/tables.coffee %}
{% include scripts/form.coffee %}
#$('#prova').DataTable()

# Start table chain
$
  .when do table_numbers
  .then do table_durations
  .then do table_sort
  .then do datetime