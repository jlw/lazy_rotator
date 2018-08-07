# LazyRotator

Tie log (or other file) rotation to the (un-scheduled?) execution of code. The _raison d'étre_ for this gem is that I'm too lazy to clear out test and development logs manually and am too anal-retentive to be happy with large log files accumulating in my various project directories.

On those rare occasions when I do want to look at a log file in my development environment, I don't want to waste time skipping past megabytes of older log entries. On the other hand, I might have restarted my app server or run tests (maybe a different set) again before deciding to look at the logs, so I don't want to simply truncate the log files on each run - keeping a few very recent files around seems to be a useful compromise.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lazy_rotator', group: %i(development test)
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lazy_rotator

## Usage

For a Rails app, add the following to `config/application.rb`:

```ruby
if defined?(LazyRotator) && (Rails.env.test? || Rails.env.development?)
  LazyRotator.rotate(File.expand_path("../log/#{Rails.env}.log", __dir__))
end
```

_Note:_ you will probably need to update your `.gitignore` file to match `/log/*.log*` - that trailing `*` will catch the rotated files.

Set the number of copies to keep (the default is 5):
```ruby
LazyRotator.rotate('path/to/log', 20)
```


## Contributing

[Bug reports and pull requests are welcome.](CONTRIBUTING.md)
