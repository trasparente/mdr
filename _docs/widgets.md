---
order: 2
form:
 
  # File path to edit inside '_data'
  # Format: 'folder/file.ext'
  # Required
  file: fields.json

  # Timestamp to save as 'folder/{timestamp}.ext'
  # Form class list
  # Optional
  timestamp: true

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
      title: Label string
      default: default string

    # Textarea
    textarea:
      type: textarea
      # Optional
      placeholder: Textarea

    # Number
    number:
      type: number
      # Optional
      default: 0

    # Boolean
    boolean:
      type: boolean
      # Default to 0, false
      # Optional
      default: 1

    # Color
    color:
      type: color
      # Optional
      default: "#000"

    # Date picker
    date:
      type: date
      # Default value accept 'today'
      default: today

    # Select from list
    select:
      type: select
      options: [Saved,As,String]
      default: As

    # Select multiple
    select_multiple:
      type: select
      options: [Multiple,Choice]
      multiple: true

    # Reference:
    # select from external csv
    reference:
      type: ref
      # csv file name inside '_data'
      csv: time
      # Column name to gather
      property: date

    # Pick a property from a random line in a csv
    random:
      type: random
      # csv file name inside '_data'
      csv: stones
      # Column name to pick
      property: dead

    # Roll dices at site deploy
    roll:
      type: roll
      roll: 3d6

    # Roll and index a value/name csv
    roll_csv:
      type: roll
      roll: 3d6
      csv: agency
      property: name
---
# Widgets
{:.no_toc}
- toc
{:toc}

{% include widgets/api.html include='page/navigation' %}
{% include widgets/api.html include='widgets/view' %}
{% include widgets/api.html include='widgets/form' %}
{% include widgets/form.html form=page.form %}
{% include widgets/api.html %}
{% include widgets/api.html include='widgets/github_url' %}
{% include widgets/api.html include='widgets/github_link' %}
{% include widgets/api.html include='scripts/time.coffee' %}
{% include widgets/api.html include='widgets/first.html' %}
{% include widgets/api.html include='widgets/last.html' %}
{% include widgets/api.html include='widgets/repos.html' %}
{% include widgets/repos.html %}