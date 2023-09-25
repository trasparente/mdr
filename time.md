---
title: Time
form:
  file: time.csv
  fields:
    date:
      type: date
      default: today
    category: true
    details: true
    value:
      type: number
    duration: true
---
{:toc}
- toc
{% include widgets/form.html %}
{:.language-liquid}
    {% raw %}{% include widgets/form.html %}{% endraw %}

{% include widgets/view.html csv="time" category="trash" %}
{:.language-liquid}
    {% raw %}{% include widgets/view.html csv="time" category="trash" %}{% endraw %}

{% include widgets/view.html csv="time" category="briefing" limit="4" %}
{:.language-liquid}
    {% raw %}{% include widgets/view.html csv="time" category="briefing" limit="4" %}{% endraw %}

{% include widgets/view.html csv="time" category="bill" limit="4" %}
{:.language-liquid}
    {% raw %}{% include widgets/view.html csv="time" category="bill" limit="4" %}{% endraw %}

{% include widgets/view.html csv="time" category="yaris, kangoo, citroen" title="cars" %}
{:.language-liquid}
    {% raw %}{% include widgets/view.html csv="time" category="yaris, kangoo, citroen" title="cars" %}{% endraw %}

<details markdown=1>
<summary><code>csv=time</code></summary>

{% include widgets/view.html csv="time" %}

</details>
<style>
td[data-value='briefing']{color:var(--color-green)}
td[data-value='bill']{color:var(--color-orange)}
td[data-value='trash']{color:var(--fg-muted)}
</style>