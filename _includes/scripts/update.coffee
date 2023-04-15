check_update = ->
  commits = $.get github_repo_url + '/commits'

  commits.done (data) ->
    [latest_date, latest_sha] = [
      data[0].commit.author.date
      data[0].sha
    ]
    same_sha = latest_sha is '{{ site.github.build_revision }}'
    build_post_commit = +new Date(latest_date) / 1000 < {{ site.time | date: "%s" }}
    console.log same_sha,build_post_commit
    console.log [latest_date, latest_sha]
    console.log ['{{ site.time | date_to_xmlschema }}','{{ site.github.build_revision }}']
    if same_sha and build_post_commit
      html.addClass 'updated'
    else
      html.removeClass 'updated'
      # Schedule next check in 1 minute
      setTimeout check_update, 1000*10
    return do check_login

  return # End check_update