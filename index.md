---
title: Home
prova:
  file: agents.json
  timestamp: 1
  fields:
    name:
      type: pick
      csv: stones
      property: dead
    # roll is a number
    3d6:
      type: roll
      roll: 3d6
    # tables
    agency:
      type: table
      table: agency
      roll: 3d6
    reaction:
      type: table
      table: reaction
      roll: 3d6
---
## todo

- archive of yml timestamps

{% include widgets/form.html form=page.prova %}