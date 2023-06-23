---
permalink: practices/
form:
  class: admin
  type: append
  file: practices.csv
  fields:
    date:
      type: date
      default: today
    serie:
      type: select
      default: [1,2,3,4]
---
Practices
=========

{% assign count = 0 %}{% assign total = 0 %}{% assign not = 0 %}
{% for d in (0..59) reversed %}{% assign gap = d | times: 86400 %}{% assign day = site.time | date: "%s" | minus: gap | date: "%F" %}{% assign is = site.data.practices | where: "date", day | size %}{% if is > 0 %}{% assign count = count | plus: 1 %}{% assign total = total | plus: 1 %}{% assign not = 0 %}<code data-serie='{{ site.data.practices | where: "date", day | map: "serie" }}'>{{ count }}</code>{% else %}{% assign not = not | plus: 1 %}<code>{{ not }}</code>{% assign count = 0 %}{% endif %}{% endfor %}

|{{ site.time | date: "%s" | minus: 5097600 | date: "%-d/%-m" }}|Practices||%
|--|--|--|--
|60|{{ total }}|<progress max="60" value="{{ total }}"></progress>|{{ total | times: 100 | divided_by: 60 }}
{% assign year = site.time | date: "%Y" %}
{% assign day = site.time | date: "%j" %}
{% assign years = site.data.practices | sort: "date" | reverse | group_by_exp: "item", "item.date | slice: 0, 4" %}
|Year|Practices||%
|-|-|-|
{% for y in years %}|{{ y.name }}|{{ y.items.size }}|{% if y.name == year %}{% assign prog = y.items.size | times: 100 | divided_by: day %}{% else %}{% assign prog = y.items.size | times: 100 | divided_by: 365 %}{% endif %}<progress max="100" value="{{ prog }}"></progress>|{{ prog }}
{% endfor %}

||Practices|First|Last
|--:|--:|--:|--:|
|First|{{ site.data.practices | where: "serie", 1 | size }}|{% include widgets/first.html data=site.data.practices field='serie' value='1' %}|{% include widgets/last.html data=site.data.practices field='serie' value='1' %}
|Second|{{ site.data.practices | where: "serie", 2 | size }}|{% include widgets/first.html data=site.data.practices field='serie' value='2' %}|{% include widgets/last.html data=site.data.practices field='serie' value='2' %}
|Total|{{ site.data.practices.size }}

<style>
time>span{color:var(--fg-muted)}
[data-serie='2']{color: var(--color-red)}
[data-serie='1']{color: var(--color-green)}
main code:not([data-serie]){opacity: .3}
</style>
{% include widgets/form.html %}