---
---
Repos
=====
{% assign repos = site.github.public_repositories | sort: 'pushed_at' | reverse %}
<table>
<thead><tr><th>Name</th><th>Pushed</th><th>Created</th><th>URL</th><th>HTML</th></tr></thead><tbody>{% for repo in repos %}
<tr><td><span title='{{ repo.description }}'>{{ repo.name }}</span></td><td><time datetime='{{ repo.pushed_at | date_to_rfc822 }}'></time></td><td><time datetime='{{ repo.created_at | date_to_rfc822 }}'></time></td><td><a href="{{ repo.html_url }}">{{ repo.full_name }}</a></td><td>{% if repo.has_pages %}<a href="https://{{ repo.owner.login }}.github.io/{{ repo.name }}">pages</a>{% elsif repo.fork %}fork{% endif %}</td></tr>
{% endfor %}</tbody>
</table>