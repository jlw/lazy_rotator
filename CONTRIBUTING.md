# Contributing

If you discover issues, have ideas for improvements or new features, please report them to the [issue tracker][1] of the repository or submit a pull request. Please, try to follow these guidelines when you do so.

## Issue reporting

- Check that the issue has not already been reported.
- Check that the issue has not already been fixed in the latest code (a.k.a. `master`).
- Be clear, concise and precise in your description of the problem.
- Open an issue with a descriptive title and a summary in grammatically correct, complete sentences.
- Include any relevant code to the issue summary.

## Pull requests

- Read [how to properly contribute to open source projects on GitHub][2].
- Fork the project.
- Use a topic/feature branch to easily amend a pull request later, if necessary.
- Write [good commit messages][3].
- Use the same coding conventions as the rest of the project.
- Commit and push until you are happy with your contribution.
- If your change has a corresponding open GitHub issue, prefix the commit message with `[Fix #github-issue-number]`.
- Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
- Add an entry to the [Change Log](CHANGELOG.md) accordingly.
- Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.
- Make sure the test suite is passing for all supported Ruby versions: `./all_rubies bundle && ./all_rubies spec`.
- Make sure the code you wrote doesn't produce RuboCop offenses `./all_rubies cop`.
- [Squash related commits together][5].
- Open a [pull request][4] that relates to _only_ one subject with a clear title and description in grammatically correct, complete sentences.

[1]: https://github.com/jlw/lazy_rotator/issues
[2]: http://gun.io/blog/how-to-github-fork-branch-and-pull-request
[3]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
[4]: https://help.github.com/articles/about-pull-requests
[5]: http://gitready.com/advanced/2009/02/10/squashing-commits-with-rebase.html
