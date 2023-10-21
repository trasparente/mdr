---
order: 1
---
# Configuration
{:.no_toc}
- toc
{:toc}

### Setup

1. New repository with jekyll `.gitignore` file
2. Add `_config.yml` file with `remote_theme: trasparente/mdr@gh-pages`
3. Select branch in repository `Settings > Pages > Branch`
4. Custom style in `_sass/_custom.sass`
5. Custom coffeescripts in `_includes/scripts/custom.coffee`
6. Put `favicon.ico` and `favicon.png` somewhere

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