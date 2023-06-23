---
title: Home
form:
  class: admin
  type: append
  file: cluster.csv
  fields:
    name:
      type: pick
      csv: stones
      property: dead
    x:
      type: roll
      roll: 3
      dice: 6
    y:
      type: roll
      roll: 3
      dice: 6
    z:
      type: roll
      roll: 3
      dice: 6
---
{% include widgets/form.html form=page.form %}