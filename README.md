# RSpecSnapshotMatcher

This gem was inspired by the snapshot feature of Facebook's Jest Javascript testing framework.  At first, I considered the behavior of dubious value because it seemed like it is largely an implementation of the Guru Checks Output anti-pattern.

If you find yourself in a situation where it is difficult to refactor confidently because you have missing coverage in other test suites, then the snapshot matcher can give you a quick and dirty sanity check.

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

