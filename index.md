---
title: Home
form:
  class: admin
  type: append
  file: cluster.csv
  fields:
    name:
      type: load
      url: stonelore/stone/_data/stones.csv
    x:
      type: roll
      dice: 3d6
    y:
      type: roll
      dice: 3d6
    z:
      type: roll
      dice: 3d6
---
{% include widgets/form.html form=page.form %}