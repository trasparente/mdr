---
---
# Home

Lorem ipsum dolor, sit amet **consectetur** *adipisicing* elit. Labore possimus consequuntur pariatur `cupiditate` quo! Rerum unde quod perferendis explicabo distinctio.

Table
-----

<details>
<summary>Time</summary>
<table id='prova'>
  {% for row in site.data.time %}
    {% if forloop.first %}
    <thead><tr class='rowheader'>
      {% for pair in row %}
        <th class='col{{ forloop.index }}'>{{ pair[0] }}</th>
      {% endfor %}
    </tr></thead><tbody>
    {% endif %}
    {% tablerow pair in row %}
      {{ pair[1] }}
    {% endtablerow %}
  {% endfor %}
  </tbody>
</table>
</details>

## Code

{% include widgets/code.html %}

## Colors classes

{% include widgets/colors.html %}