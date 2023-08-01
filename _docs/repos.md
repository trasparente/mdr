---
---
Repos
=====
```liquid
{% raw %}{% assign repos = site.github.public_repositories | sort: 'pushed_at' | reverse %}{% endraw %}
```
{% assign repos = site.github.public_repositories | sort: 'pushed_at' | reverse %}

|Name|Pushed|Created|URL|HTML
|:---|:---|:---|:---|:---
{% for repo in repos %}|<span title='{{ repo.description }}'>{{ repo.name }}</span>|<time datetime='{{ repo.pushed_at | date_to_rfc822 }}'></time>|<time datetime='{{ repo.created_at | date_to_rfc822 }}'></time>|[{{ repo.full_name }}]({{ repo.html_url }})|{% if repo.has_pages %}[pages](https://{{ repo.owner.login }}.github.io/{{ repo.name }}){% elsif repo.fork %}fork{% endif %}|
{% endfor %}