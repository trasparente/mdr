---
title: Time
form:
  class: admin
  type: append
  file: time.csv
  fields:
    date:
      type: date
      default: today
    category: true
    details: true
    value:
      type: number
    duration: true
---
{% include widgets/table.html csv="time" category="trash" %}
{% include widgets/table.html csv="time" category="bill" limit="4" %}
{% include widgets/table.html csv="time" category="yaris, kangoo, citroen" %}
{% include widgets/table.html csv="time" category="briefing" limit="4" %}
{% include widgets/form.html form=page.form %}