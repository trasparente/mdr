---
order: 1
---
# Configuration
{:.no_toc}
- toc
{:toc}

### Setup

1. New repository with jekyll `.gitignore` file.
2. Add `_config.yml` file with `remote_theme: trasparente/mdr@gh-pages`.
3. Select branch in repository Settings > Pages > Branch.

Other jekyll options:
```yml
timezone: Europe/Rome
permalink: pretty
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
    title: Posts
```