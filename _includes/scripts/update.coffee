@check_update = -> $.get
  url: github_repo_url + '/commits'
  success: (commits) ->
    [latest_date, latest_sha] = [
      commits[0].commit.author.date
      commits[0].sha
    ]
    same_sha = latest_sha is '{{ site.github.build_revision }}'
    build_post_commit = +new Date(latest_date) / 1000 < {{ site.time | date: "%s" }}
    if same_sha and build_post_commit
      html.removeClass('behind').addClass 'updated'
    else html.addClass('behind').removeClass 'updated'
    return

@check_parent = -> $.get
  url: "{{ site.github.api_url }}/repos/#{localStorage.getItem 'parent'}/commits"
  success (commits) ->
    [latest_date, latest_sha] = [
      commits[0].commit.author.date
      commits[0].sha
    ]
    same_sha = latest_sha is '{{ site.github.build_revision }}'
    build_post_commit = +new Date(latest_date) / 1000 < {{ site.time | date: "%s" }}
    if !same_sha and !build_post_commit
      # Sync with upstream
      # https://docs.github.com/en/rest/branches/branches#sync-a-fork-branch-with-the-upstream-repository
      sync = $.ajax github_repo_url + '/merge-upstream',
        method: 'POST'
        data: JSON.stringify {"branch": localStorage.getItem 'branch' }
      sync.done (data) -> alert 'Synched with upstream branch'
    # If repository is ahead, need pull
    else console.log 'open pull'
    return # End check_parent