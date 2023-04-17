---
title: Home
form:
  class: admin
  type: append
  file: time.csv
  fields:
    - name: date
      type: date
      default: today
    - name: category
    - name: details
    - name: value
      type: number
---
{% include widgets/form.html form=page.form %}
{% include widgets/table.html csv="time" category="trash" %}
{% include widgets/table.html csv="time" category="bill" limit="4" %}
{% include widgets/table.html csv="time" category="yaris, kangoo, citroen" %}
{% include widgets/table.html csv="time" category="briefing" limit="4" %}