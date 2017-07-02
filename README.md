# Rspec::Snapshot::Matcher

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/rspec/snapshot/matcher`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec_snapshot_matcher'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec_snapshot_matcher

## Usage

In your rspec helper

```ruby
require 'rspec_snapshot_matcher'
```

Then, in your tests, use the matcher to compare an object to the snapshot for that test.

```ruby
describe 'some request, method, whatever' do
  it 'should render the desired html, string, hash, object, struct, ... you name it' do
    get some_path
    expect(response.body).to match_snapshot
  end

  it 'should work with just about anything really' do
    model = service.get_something
    expect(model).to match_snapshot
  end
end
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rspec-snapshot-matcher.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

