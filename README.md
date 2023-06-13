# OpenGCS

OpenGCS is a wrapper to open files from Google Cloud Storage (GCS), inspired by [OpenURI](https://github.com/ruby/open-uri).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'open-gcs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install open-gcs

## Usage

### Basic Usage

```ruby
OpenGCS.open_gcs('gs://your-bucket/your-file') { |file|
  file.each_line { |line| puts line }
}
```

### Wrapping to `File.open`

```ruby
class YourClass
  using OpenGCSExt

  File.open('gs://your-bucket/your-file') { |file|
    file.each_line { |line| puts line }
  }
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tomog105/open-gcs.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
