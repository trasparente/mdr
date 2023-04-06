---
---
import { Octokit } from "https://cdn.skypack.dev/pin/@octokit/rest@v19.0.7-fuuyWKgN6s3HuZefQFbU/mode=imports,min/optimized/@octokit/rest.js"

octokit = new Octokit()

octo = octokit.request 'GET /repos/{owner}/{repo}/commits',
  owner: '{{ site.github.owner_name }}'
  repo: '{{ site.github.project_title }}'

sync = octo.then (commits) ->
  [latest_date, latest_sha] = [
    commits.data[0].commit.author.date
    commits.data[0].sha
  ]
  unix = +new Date latest_date
  console.log unix / 1000 < {{ site.time | date: "%s" }}