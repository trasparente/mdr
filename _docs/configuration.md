---
order: 1
---
# Configuration
{:.no_toc}
- toc
{:toc}

### Setup

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
- Custom styles in `_sass/_custom.sass`
- Custom coffeescripts in `_includes/scripts/custom.coffee`
- Custom favicons files `favicon.ico` and `favicon.png` somewhere
- Pages as `.md` files in the root or in `assets` with `permlink: page_name/`
- Collections in the root `_collection_name` with `order: n`
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