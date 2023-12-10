---
title: Home
table:
  -
    date: 2020-01-02
    header: value
    num: 3
    "%": 3
  -
    date: 2023-01-02
    header: ciro
    num: 54
    "%": 54
---
{% include widgets/view.html liquid=page.table %}

{% include widgets/calendar.html csv='practice' property='serie' %}

|{{ site.time | date: "%s" | minus: 5097600 | date: "%-d/%-m" }}|Practices||%
|--|--|--|--
|<span style='visibility:hidden'>00</span>60|{{ total }}|<progress max="60" value="{{ total }}"></progress>|{{ total | times: 100 | divided_by: 60 }}
{% assign year = site.time | date: "%Y" %}
{% assign day = site.time | date: "%j" %}
{% assign years = site.data.practices | sort: "date" | reverse | group_by_exp: "item", "item.date | slice: 0, 4" %}
|Year|Practices||%
|-|-|-|
{% for y in years %}|{{ y.name }}|{{ y.items.size }}|{% if y.name == year %}{% assign prog = y.items.size | times: 100 | divided_by: day %}{% else %}{% assign prog = y.items.size | times: 100 | divided_by: 365 %}{% endif %}<progress max="100" value="{{ prog }}"></progress>|{{ prog }}
{% endfor %}
