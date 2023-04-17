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