---
permalink: practices/
---
Practices
=========

{% assign count = 0 %}{% assign total = 0 %}
<code>{% for d in (1..60) reversed %}{% assign gap = d | times: 86400 %}{% assign day = site.time | date: "%s" | minus: gap | date: "%F" %}{% assign is = site.data.practices | where: "date", day | size %}{% if is > 0 %}{% assign count = count | plus: 1 %}{% assign total = total | plus: 1 %}{{ count }}{% else %}-{% assign count = 0 %}{% endif %}{% endfor %}</code>
<progress max="60" value="{{ total }}"></progress>{{ total | times: 100 | divided_by: 60 }}%
{% assign year = site.time | date: "%Y" %}
{% assign day = site.time | date: "%j" %}
{% assign years = site.data.practices | sort: "date" | reverse | group_by_exp: "item", "item.date | slice: 0, 4" %}
|Year|Practices||%
|-|-|-|
{% for y in years %}|{{ y.name }}|{{ y.items.size }}|{% if y.name == year %}{% assign prog = y.items.size | times: 100 | divided_by: day %}{% else %}{% assign prog = y.items.size | times: 100 | divided_by: 365 %}{% endif %}<progress max="100" value="{{ prog }}"></progress>|{{ prog }}
{% endfor %}