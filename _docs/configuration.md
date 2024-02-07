---
order: 1
---
# Configuration
{:.no_toc}
- toc
{:toc}

## Setup

1. New repository with jekyll `.gitignore` file
2. Select pages branch in repository `Settings > Pages > Branch`
3. Add `_config.yml` file with `remote_theme: trasparente/mdr@gh-pages`

```yml
# _config.yml
timezone: Europe/Rome
permalink: pretty
remote_theme: trasparente/mdr@gh-pages

# DEFAULTS
defaults:
  - scope:
      path: ''
    values:
      layout: default

# COLLECTIONS
collections:
  docs:
    title: Docs
    output: true
  posts:
    title: Blog
```

<fieldset markdown='1'><legend>Customization</legend>

- Custom styles in `_sass/_custom.sass`
- Custom coffeescripts in `_includes/scripts/custom.coffee`
- Custom favicons files `favicon.ico` and `favicon.png` somewhere

</fieldset>
<fieldset markdown='1'><legend>Content</legend>

- Pages as `.md` files in the root or in `assets` with `permlink: page_name/`
- Collections in the root `_collection_name` with `order: n`

</fieldset>
<fieldset markdown='1'><legend>Rebuild</legend>

- Rebuild at midnight with `.github/workflows/build_pages.yml`

```yml
name: Request pages build with GitHub CLI
on:
  schedule:
    - cron: 0 0 * * *
jobs:
  build_pages:
    runs-on: ubuntu-latest
    steps:
      - run: gh api -X POST repos/${% raw %}{{ github.repository }}{% endraw %}/pages/builds
        env:
          GITHUB_TOKEN: ${% raw %}{{ secrets.GITHUB_TOKEN }}{% endraw %}
```
</fieldset>

## Theme

[Link](#)
<button>Button</button>
<details>
<summary>Details</summary>
Content
</details>

{% assign colors = "red,orange,yellow,green,forest,cyan,blue,violet,purple,magenta,pink" | split: ',' %}

<!-- COLOR -->

<fieldset><legend markdown='1'>Color classes `.color-{color}`{:.language-css}</legend>
<span class='color-fg'>.color-fg</span>
<span class='color-muted'>.color-muted</span>
<span class='color-link'>.color-link</span>
{% for c in colors %}<span class='color-{{c}}'>.color-{{c}}</span>
{% endfor %}
</fieldset>

<!-- BACKGROUND -->

<fieldset><legend markdown='1'>Background classes `.background-{color}`{:.language-css}</legend>
<span style='padding:1em;display:inline-block' class='background-bg'>.background-bg</span><span style='padding:1em;display:inline-block' class='background-muted'>.background-muted</span>{% for c in colors %}<span style='padding:1em;display:inline-block' class='background-{{c}}'>.background-{{c}}</span>{% endfor %}
</fieldset>

<fieldset markdown='1'><legend markdown='1'>Accent classes: `.accent-{color}`{:.language-css}</legend>coordinates links, navigation and border colors; affects `<blockquote>`{:.language-html} and `<fieldset>`{:.language-html} too.
</fieldset>

<fieldset markdown='1'><legend>Blink classes</legend>
- <span class='background-muted blink'>.blink</span>
- <span class='background-muted foreground-blink'>.foreground-blink</span>
- <span class='background-muted background-blink'>.background-blink</span>
</fieldset>

## User/fork data

Exposed are two `json` endpoints:
- `{{ 'assets/data/user.json' | absolute_url }}` is queried for user data
- `{{ 'assets/data/fork.json' | absolute_url }}`