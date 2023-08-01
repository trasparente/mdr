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
{% include widgets/form.html %}
{% include widgets/view.html csv="time" category="trash" %}
{% include widgets/view.html csv="time" category="briefing" limit="4" %}
{% include widgets/view.html csv="time" category="bill" limit="4" %}
{% include widgets/view.html csv="time" category="yaris, kangoo, citroen" %}

<style>
td[data-value='briefing']{color:var(--color-green)}
td[data-value='bill']{color:var(--color-orange)}
td[data-value='trash']{color:var(--fg-muted)}
</style>