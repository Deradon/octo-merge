[![Build Status](https://travis-ci.org/Deradon/octo-merge.svg?branch=master)](https://travis-ci.org/Deradon/octo-merge)

# OctoMerge

`octo-merge` is a simple command line tool to merge GitHub pull requests using different strategies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'octo-merge'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install octo-merge

## Setup / Configure

If you do not want to provide your GitHub login credentials every time you
call `octo-merge` you can easily set these in your `~/.octo-merge.yml`.

Feel free to use the included setup task:

```
octo-merge --setup
```

## Examples

```
# Within your shell

octo-merge \
  --repo=rails/rails \
  --dir=~/Dev/Rails/rails \
  --pull_requests=23,42 \
  --login=Deradon \
  --password=<your-github-API-token> \
  --strategy=MergeWithRebase
```

* You can find your API token [here](https://github.com/settings/tokens)

## Available Strategies

* NOTE: All strategies are using read-only branches for a specific pull requests.
        This way we avoid adding lot of remotes.
* Read more: [Checking out pull requests locally](https://help.github.com/articles/checking-out-pull-requests-locally/)

### MergeWithoutRebase

```
# Reset master
git checkout master
git fetch upstream
git reset --hard upstream/master

# For each pull request
  git fetch upstream pull/23/head:pull/23 --force"
  git merge --no-ff pull/23
  git branch -D pull/23
```

### MergeWithRebase

```
# Reset master
git checkout master
git fetch upstream
git reset --hard upstream/master

# For each pull request
  git fetch upstream pull/23/head:pull/23 --force"
  git checkout pull/23
  git rebase master

  git checkout master
  git merge --no-ff pull/23

  git branch -D pull/23
```

### Rebase

```
# Reset master
git checkout master
git fetch upstream
git reset --hard upstream/master

# For each pull request
  git fetch upstream pull/23/head:pull/23 --force"
  git checkout pull/23
  git rebase master

  git checkout master
  git rebase pull/23

  git branch -D pull/23
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Deradon/octo-merge. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

