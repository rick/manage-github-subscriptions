### License Checker

Use the [GitHub API](https://developer.github.com/v3/) to manage GitHub
repository notification subscription lists.

### Usage

 - [Create a GitHub personal access token.](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) This should be made by a member of the organization who can see private repositories (e.g., a member of the `Owners` team).
 - Place the access token in the file `~/.github.yml`:

``` yaml
token: 1234567890feedfacedeadbeefcafe0987654321
```

 - Create a text file in `~/.github/subscribed-repos.txt` which lists each repository you wish to be subscribed to, in the format `owner/reponame`, one per line.

 - Bundle, and run the script:

```
$ bundle install --path vendor/bundler
$ bundle exec script/manage-notifications.rb
```

You can also set the environment variable `$DEBUG` if you want more verbose output during the fetch process.
