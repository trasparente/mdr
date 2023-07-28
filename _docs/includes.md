---
form:
 
  # File path to edit inside '_data'
  # Format: 'folder/file.ext'
  # Required
  file: example.json
 
  # Form class list
  # Default: 'admin'
  # Optional
  class: admin
 
  # Form field as yaml fields
  # Columns if file is 'csv'
  # Properties if file is 'json' or 'yaml'
  fields:

    # Text, implicit
    text: true
    # Text, explicit
    text:
      type: text
      # Optional
      default: default string

    # Number
    number:
      type: number
      # Optional
      default: 0
 
    # Date picker
    date:
      type: date
      # Default value accept 'today'
      default: today

    # Select from list
    select:
      type: select
      default: [1,2,3,4]

    # Reference:
    # select from external csv
    reference:
      type: ref
      # csv file name inside '_data'
      csv: time
      # Column name to gather
      property: date

    # Pick a property from a random line in a csv
    pick:
      type: pick
      # csv file name inside '_data'
      csv: stones
      # Column name to pick
      property: dead

    # Roll dices at site deploy
    roll:
      type: roll
      # Number of rolls
      roll: 3
      # Number of sides
      dice: 6
      # Optional numeric modifier
      mod: 0
---
# Includes
{:.no_toc}
- toc
{:toc}

{% include widgets/api.html include='widgets/table' %}
{% include widgets/api.html include='widgets/form' %}
{% include widgets/form.html form=page.form %}
{% include widgets/api.html %}
