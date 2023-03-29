# OctoKit 19.0.7 https://octokit.github.io/rest.js/v19
import { Octokit } from "https://cdn.skypack.dev/pin/@octokit/rest@v19.0.7-fuuyWKgN6s3HuZefQFbU/mode=imports,min/optimized/@octokit/rest.js"

octokit = new Octokit()

sync = -> octokit.request 'GET /repos/{owner}/{repo}/commits',
    owner: 'trasparente'
    repo: 'mdr'
  .then (commits) ->
    [latest_date, latest_sha] = [
      commits.data[0].commit.author.date
      commits.data[0].sha
    ]
    unix = +new Date latest_date
    if unix / 1000 > {{ site.time | date: "%s" }}
      console.log 'behind'
    else console.log 'sync'